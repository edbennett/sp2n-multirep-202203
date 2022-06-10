#!/usr/bin/env python

from numpy import loadtxt
import pandas as pd

from plaq_table import get_ensembles, SUFFIX_FORMAT
from summarize import get_data_filename, get_observable


def get_args():
    from argparse import ArgumentParser, FileType

    parser = ArgumentParser()
    parser.add_argument('ensembles_file')
    parser.add_argument('--data_dir', default='processed_data')
    parser.add_argument('--output_file', type=FileType('w'), default='-')
    return parser.parse_args()


def column_name(rep, channel, observable, suffix):
    return '{observable}{channel}{rep}{suffix}'.format(
        observable=observable,
        channel=channel,
        rep=f'_{rep}' if rep else '',
        suffix=f'_{suffix}' if suffix else ''
    )


def get_plaq(data_dir, ensemble):
    return loadtxt('{data_dir}/plaq_avg_{suffix}.txt'.format(
        data_dir=data_dir,
        suffix=SUFFIX_FORMAT.format(**ensemble)
    ))


def main():
    args = get_args()
    ensembles = get_ensembles(args.ensembles_file)
    results = []

    channel_specs = [
        (None, 'ch', 'm'),
        ('fun', 'ps', 'f'),
        ('asy', 'ps', 'f')
    ] + [
        (rep, chan, 'm')
        for rep in ('fun', 'asy')
        for chan in ('ps', 'v', 'av', 't', 'at', 's')
    ]

    for ensemble in ensembles.values():
        record = {**ensemble}
        for spec in channel_specs:
            try:
                result = get_observable(args.data_dir, ensemble, *spec)
            except IOError:
                continue
            record[column_name(*spec, 'value')] = result.nominal_value
            record[column_name(*spec, 'error')] = result.std_dev

        plaquette = get_plaq(args.data_dir, ensemble)
        record['plaq_value'] = plaquette[0]
        record['plaq_error'] = plaquette[1]

        results.append(record)

    df = pd.DataFrame.from_records(results)
    df.to_csv(args.output_file, index=False)


if __name__ == '__main__':
    main()
