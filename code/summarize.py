#!/usr/bin/env python

from numpy import loadtxt

from uncertainties import ufloat

from plaq_table import get_ensembles


def get_data_filename(data_dir, ensemble, rep, channel):
    return (
        '{data_dir}/corr_{channel}_fit_{rep}{T}x{L}x{L}x{L}'
        'b{beta}mas{mas}mf{mf}.txt'
    ).format(
        data_dir=data_dir,
        channel=channel,
        rep=((rep + '_') if rep else ''),
        T=ensemble['Nt'],
        L=ensemble['Ns'],
        beta=ensemble['beta'],
        mas=ensemble['m_asy'],
        mf=ensemble['m_fun']
    )


def get_args():
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.add_argument('ensembles_file')
    parser.add_argument('--data_dir', default='processed_data')
    parser.add_argument('--output_dir', default='processed_data')
    return parser.parse_args()


def get_observable(data_dir, ensemble, rep, channel, observable,
                   sentinel=None):
    power = 0.5
    max_rows = 2
    offset = 1
    if channel == 'ps':
        max_rows = 3
        if observable == 'f':
            offset = 0
    elif observable != 'm':
        raise ValueError(
            f'Bad combination of {channel=} and {observable=}'
        )

    if channel == 'ch':
        power = 1

    try:
        data = loadtxt(get_data_filename(data_dir, ensemble, rep, channel),
                       max_rows=max_rows) ** power
    except IOError:
        if sentinel:
            return sentinel
        else:
            raise

    return ufloat(data[offset].mean(), data[offset].std())


def format_single_value(result):
    return f'{result.n} {result.s}'


def format_mathematica(data_dir, ensembles, rep, channel, observable):
    formatted_values = []
    for ensemble in ensembles.values():
        result = get_observable(data_dir, ensemble, rep, channel, observable,
                                sentinel=ufloat(-1, 0.01))
        formatted_values.append(format_single_value(result))
    return '\n'.join(formatted_values)


def print_to_filename(value, filename):
    with open(filename, 'w') as f:
        print(value, file=f)


def get_output_filename(output_dir, rep, channel, observable):
    return '{output_dir}/summary_{observable}{channel}{rep}.txt'.format(
        output_dir=output_dir,
        channel=channel,
        rep=(('_' + rep) if rep else ''),
        observable=observable
    )


def format_all_channels_mathematica(data_dir, ensemble, rep):
    formatted_values = []
    for channel in 'ps', 'v', 't', 'av', 'at', 's':
        result = get_observable(data_dir, ensemble, rep, channel, 'm',
                                sentinel=ufloat(-1, 0.01))
        formatted_values.append(format_single_value(result))
    return '\n'.join(formatted_values)


def main():
    args = get_args()
    ensembles = get_ensembles(args.ensembles_file)
    print_to_filename(
        format_mathematica(args.data_dir, ensembles, None, 'ch', 'm'),
        get_output_filename(args.output_dir, None, 'ch', 'm')
    )
    for rep in 'fun', 'asy':
        print_to_filename(
            format_mathematica(args.data_dir, ensembles, rep, 'ps', 'f'),
            get_output_filename(args.output_dir, rep, 'ps', 'f')
        )
        for channel in 'ps', 'v', 'av', 't', 'at', 's':
            print_to_filename(
                format_mathematica(
                    args.data_dir, ensembles, rep, channel, 'm'
                ),
                get_output_filename(args.output_dir, rep, channel, 'm')
            )

    large_ensemble = sorted(ensembles.values(), key=lambda v : v['Ns'])[-1]
    print_to_filename(
        format_single_value(get_observable(
            args.data_dir, large_ensemble, None, 'ch', 'm',
            sentinel=ufloat(-1, 0.01))),
        args.output_dir + '/large_ch.txt'
    )
    print_to_filename(
        format_all_channels_mathematica(args.data_dir, large_ensemble, 'asy'),
        args.output_dir + '/large_asy.txt'
    )
    print_to_filename(
        format_all_channels_mathematica(args.data_dir, large_ensemble, 'fun'),
        args.output_dir + '/large_fun.txt'
    )


if __name__ == '__main__':
    main()
