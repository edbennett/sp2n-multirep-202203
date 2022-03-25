#!/usr/bin/env python

from uncertainties.core import AffineScalarFunc, Variable

from plaq_table import get_ensembles
from summarize import get_observable, get_args, print_to_filename

def _get_observable(*args, **kwargs):
    try:
        return get_observable(*args, **kwargs)
    except OSError:
        return '---'


def tabulate(headings, data):
    header = r'\begin{{tabular}}{{|{columnspec}|}}'.format(
        columnspec='|'.join(['c' for _ in headings])
    ) + '\n\\hline\n' + ' & '.join(headings) + r'\\' + '\n\\hline\n'
    str_data = []
    for row in data:
        str_row = []
        for cell in row:
            if isinstance(cell, str):
                str_row.append(cell)
            elif (isinstance(cell, Variable)
                  or isinstance(cell, AffineScalarFunc)):
                str_row.append(f'${cell:.2ufSL}$')
            else:
                raise ValueError(f'Unexpected variable type {type(cell)}')
        str_data.append(' & '.join(str_row) + r'\\')
    footer = '\n\\hline\n' + r'\end{tabular}'

    return header + '\n'.join(str_data) + footer


def spectrum_table_fun(ensembles, data_dir):
    largest_ensemble = sorted(ensembles.values(), key=lambda v : v['Ns'])[-1]
    mps_f_inf = _get_observable(data_dir, largest_ensemble, 'fun', 'ps', 'm')

    data = []
    for ensemble in ensembles.values():
        row_content = []
        row_content.append(ensemble['name'])
        row_content.append(_get_observable(data_dir, ensemble, 'fun', 'ps', 'm'))
        row_content.append(_get_observable(data_dir, ensemble, 'fun', 'v', 'm'))
        row_content.append(_get_observable(data_dir, ensemble, 'fun', 'ps', 'f'))
        row_content.append(mps_f_inf * ensemble['Ns'])
        data.append(row_content)

    headings = [
        'Ensemble', r'$am_{\mathrm{PS}}^f$', r'$am_{\mathrm{V}}^f$',
        r'$af_{\mathrm{PS}}^f$', r'$m_{\mathrm{PS}}^{f,\mathrm{inf}}L$'
    ]

    return tabulate(headings, data)


def spectrum_table_asy(ensembles, data_dir):
    data = []
    for ensemble in ensembles.values():
        row_content = []
        row_content.append(ensemble['name'])
        row_content.append(_get_observable(data_dir, ensemble, 'asy', 'ps', 'm'))
        row_content.append(_get_observable(data_dir, ensemble, 'asy', 'v', 'm'))
        row_content.append(_get_observable(data_dir, ensemble, 'asy', 'ps', 'f'))
        row_content.append(_get_observable(data_dir, ensemble, None, 'ch', 'm'))
        data.append(row_content)

    headings = [
        'Ensemble', r'$am_{\mathrm{PS}}^{as}$', r'$am_{\mathrm{V}}^{as}$',
        r'$af_{\mathrm{PS}}^{as}$', r'$am_{\mathrm{CB}}^{+}$'
    ]

    return tabulate(headings, data)


def spectrum_table_large(ensembles, data_dir):
    data = []
    channels = ['t', 'av', 'at', 's']

    for ensemble in [ensembles['E7']]:
        row_content = []
        row_content.append(ensemble['name'])
        for rep in 'fun', 'asy':
            for channel in channels:
                row_content.append(
                    _get_observable(data_dir, ensemble, rep, channel, 'm')
                )
        data.append(row_content)

    headings = ['Ensemble']
    for rep in 'f', 'as':
        for channel in channels:
            headings.append(r'$am_{{\mathrm{{{channel}}}}}^{{{rep}}}$'.format(
                rep=rep, channel=channel.upper()
            ))

    return tabulate(headings, data)


def main():
    args = get_args()
    ensembles = get_ensembles(args.ensembles_file)
    print_to_filename(spectrum_table_fun(ensembles, args.data_dir),
                      args.output_dir + '/spectrum_fun.tex')
    print_to_filename(spectrum_table_asy(ensembles, args.data_dir),
                      args.output_dir + '/spectrum_asy.tex')
    print_to_filename(spectrum_table_large(ensembles, args.data_dir),
                      args.output_dir + '/spectrum_large.tex')


if __name__ == '__main__':
    main()
