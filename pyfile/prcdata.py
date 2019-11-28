import numpy as np, pandas as pd
import os
datpath = r'/home/astro/data/iers/data2/'
outpath = datpath+'outdata/'
if not(os.path.exists(outpath)):
    os.makedirs(outpath)
allfile = os.listdir(datpath)
nfiles = []
for i in allfile:
    if i.find('.txt') > 0:
        nfiles.append(i)

cols = ['DateTime','Name','RA','DEC','E_Theta','M_Theta']
lenn = len(nfiles)
for i in nfiles:
    ith = nfiles.index(i)
    qlist =  pd.read_csv(datpath+i,sep='\t')
    qlist.columns = cols
    qnames = list(qlist[cols[1]].drop_duplicates())
    lenq = len(qnames)
    mintheta = pd.DataFrame(columns=cols)
    nqlist = pd.DataFrame(columns=cols)
    for qn in qnames:
        qith = qnames.index(qn)
        print('qusar of:{}/{},file of:{}/{}'.format(qith+1,lenq,ith+1,lenn))
        # print(cols[1])
        # print(qn)
        thisq = qlist.loc[qlist[cols[1]] == qn].sort_values(by=[cols[4]])
        # print(thisq.head(10))
        mintheta = mintheta.append(thisq.head(1))
        nqlist = nqlist.append(thisq)
    mintheta = mintheta.sort_values(by=[cols[0]])
    name1 = 'min'+i
    name2 = 'sort'+i
    print('Writing files...')
    mintheta.to_csv(outpath+name1,sep='\t',index=False,float_format='%08.5f')
    nqlist.to_csv(outpath+name2,sep='\t',index=False,float_format='%08.5f')
print('DONE!')
