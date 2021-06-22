
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from DraggablePoint import DraggablePoint
from Interpolation import Interpolation

x=[0,1,1,0];y=[0,0,1,1];  # interpoliavimo mazgu koordinates
N=len(x);

#InterpolationMode="brokenLine"; parametroKitimas="nera";t=[];

InterpolationMode="LagrangianLine"; 
#parametroKitimas="aritmetineProgresija"; t=[];
parametroKitimas="Ciobysevo"; t=[];
#parametroKitimas="duotaLaisvai"; t=[1, 5, 7, 8];

fig = plt.figure(); ax = fig.add_subplot(111); fig.suptitle('Kreives formos valdymas pele'+'\ninterpoliavimo metodas: ' +InterpolationMode +'\nparametro seka: '+parametroKitimas, fontsize=10) # piesinys ir asys

Itp=Interpolation(InterpolationMode,parametroKitimas,t);

Itp.interpolatedCurve(x,y,ax);     # braizo pradine kreive. Veliau modifikuojant pele, sis kreipinys generuojamas is DraggablePoint

drs = []; # busimas Circle objektu sarasas   
for iv in range (0,N):  # objektu skaitliukas
    dr=DraggablePoint(x,y,ax,iv,Itp);  dr.connect(); # kiekvienam mazgui sukuriamas DraggablePoints klases instance 
    drs.append(dr);  # visi instances turi buti issaugomi sarase. Kiekviena is ju bus galima bet kada aktyvuoti, nurodant pele
    iv+=1;

plt.show()