#!/usr/bin/env python

import re

from num2tex import num2tex
import pandas as pd

D_R = {'fun': 4, 'asy': 5}


def parse_filename(filename):
    re_groups = re.match(
        '.*eigs_(?:(?P<group>su)'
        '(?P<Nc>[0-9]+)_)?([0-9]+)x(?P<LS>[0-9]+)x(?P=LS)x(?P=LS)'
        'b([0-9.]+)(?:mas([-0-9.]+))?(?:mf([-0-9.]+))?',
        filename
    ).groups()
    if re_groups[0] is None:
        group = 'Sp'
        Nc = 4
    else:
        group = re_groups[0].upper()
        Nc = int(re_groups[1])
    T = int(re_groups[2])
    L = int(re_groups[3])
    beta = float(re_groups[4])

    if re_groups[5] and re_groups[6]:
        raise ValueError("Can only have one representation")
    elif re_groups[5]:
        rep = 'asy'
        am0 = float(re_groups[5])
    elif re_groups[6]:
        rep = 'fun'
        am0 = float(re_groups[6])
    else:
        raise ValueError("Must have either fundamental or antisymmetric mass")

    return group, Nc, rep, T, L, beta, am0


def D_R(group, Nc, rep):
    if rep == 'fun':
        return Nc
    elif rep == 'asy':
        if group == 'SU':
            return Nc * (Nc - 1) // 2
        elif group == 'Sp':
            return Nc * (Nc - 1) // 2 - 1
        else:
            raise NotImplementedError
    else:
        raise NotImplementedError


def table_row(datum):
    rep_formats = {'fun': 'f', 'asy': 'as'}
    return (
        r'${group}({Nc})$ & $({formatted_rep})$ & {beta} & ${am0}$ & '
        r'{eq44_trQm2:.2f} & ${trQm2_diff_u:.1e}$').format(
            **datum,
            formatted_rep=rep_formats[datum['rep']],
            trQm2_diff_u=num2tex(datum['trQm2_diff'])
        )


def tabulate(data):
    return (
        r'''\begin{tabular}{|c|c|c|c|c|c|}
        \hline
        Gauge group & Representation & $\beta$ & $am_0$
        & $\Tr Q_m^2$ from Eq. (\ref{trqmsquared})
        & $\Delta \Tr Q_m^2$ \\
        \hline
        '''
        + ' \\\\\n'.join([table_row(datum) for datum in data])
        + ' \\\\\n\hline\end{tabular}\n'
    )


def get_row_data(filename):
    group, Nc, rep, T, L, beta, am0 = parse_filename(filename)

    # Equation 44 of paper; estimate for trace of Q_m^2
    eq44_trQm2 = 4 * D_R(group, Nc, rep) * T * L ** 3 * (4 + (am0 + 4) ** 2)
    eigenvalues = pd.read_csv(
        filename,
        names=['idx1', 'idx2', '=', 'real', 'imag'],
        delim_whitespace=True
    ).drop(columns=['idx1', 'idx2', '='])

    n_eigs = T * L ** 3 * 4 * D_R(group, Nc, rep)


    eigs_to_average = eigenvalues.real.values[:n_eigs]
    if (eigs_to_average >= 0).all():
        # Code used gives square eigenvalues
        obs_trQm2 = eigs_to_average.sum()
    else:
        # Code used gives unsquared eigenvalues
        obs_trQm2 = (eigs_to_average ** 2).sum()

    return {
        'group': group,
        'Nc': Nc,
        'rep': rep,
        'beta': beta,
        'am0': am0,
        'eq44_trQm2': eq44_trQm2,
        'trQm2_diff': abs(eq44_trQm2 - obs_trQm2)
    }


def main():
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.add_argument('filenames', metavar='filename', nargs='+')
    parser.add_argument('--output_filename', required=True)
    args = parser.parse_args()

    data = [get_row_data(filename) for filename in args.filenames]
    table_content = tabulate(data)
    with open(args.output_filename, 'w') as f:
        f.write(table_content)


if __name__ == '__main__':
    main()
