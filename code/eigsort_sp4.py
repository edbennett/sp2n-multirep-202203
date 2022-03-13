import random
import math

from argparse import ArgumentParser

from eigs_qmsquared import parse_filename, D_R

parser = ArgumentParser()
parser.add_argument('input_file')
parser.add_argument('output_file')
args = parser.parse_args()

eigs = []
count = 0.5

group, Nc, rep, T, L, beta, m0 = parse_filename(args.filename)
volume = T * L ** 3
neig = 4 * volume * D_R(group, Nc, rep)

if rep == 'fun':
   count_increment = 1
   delta = 1
elif rep == 'asy':
   count_increment = 0.5
   delta = 2
else:
   raise ValueError(f"This code can't deal with the {rep} representation.")

ncut = int(neig / delta)

for line in open(args.input_file, "r"):
   count += count_increment
   fields = line.split(' ')
   eigs.append((int(count), float(fields[4])))

nconf = int(count / neig / count_increment)

eigstmp = []
if rep == 'asy':
    for j in range(0, nconf):
        for i in range(0, ncut):
#            eigstmp.append(eigs[neig*j+i])
            eigstmp.append([
                eigs[neig*j+delta*i][0],
                0.5*(eigs[neig*j+delta*i][1] + eigs[neig*j+delta*i+1][1])
               ])
#            eigstmp.append(random.choice([eigs[neig*j+delta*i],eigs[neig*j+delta*i+1]]))
#            print(neig*j+i, eigs[neig*j+i])
elif rep == 'fun':
    for j in range(0, nconf):
        for i in range(0, ncut):
            eigstmp.append(eigs[neig*j+i])

tmp = sorted(eigstmp, key = lambda x: float(x[1]))

with open(args.output_file, "w") as f:
    for line in tmp:
        line_old = str(line)
        line_new = line_old.replace(",", "")
        f.writelines(line_new[1:-1])
#   print(*line, sep = " ")
        f.writelines("\n")
