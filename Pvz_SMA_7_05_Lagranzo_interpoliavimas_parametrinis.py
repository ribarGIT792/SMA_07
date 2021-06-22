import numpy as np
from numpy import *
import matplotlib.pyplot as plt
from matplotlib import cm
from mpl_toolkits import mplot3d
import tkinter as tk
from tkinter import * 
from PyFunkcijos import *
import math
import time


#-------- Lagranzo daugianaris -------------
def LagranzoDaugianaris(X,j,xxx):
    N=size(X);
    L=np.ones(xxx.shape,  dtype=np.double);
    for k in range(0,N) :
        if (j != k):  L=L*((xxx - X[k]) / (X[j] - X[k]))
    return L 
#----------------------------------

#-------- Lagranzo interpoliavimo funkcija -------------
def LagranzoCore( X, Y, param, nVizPoints, parametroKitimas,iReplot,T):
    T.insert(END,"\nLagranzoCore\n")
    N=size(X);
    if parametroKitimas ==  "duotosLaisvai" : t = param;
    elif parametroKitimas == "aritmetineProgresija" :
       t=np.zeros(N); 
       for i  in range (N) :  t[i] = i;
    elif parametroKitimas == "Ciobysevo" :
       t=np.zeros(N); 
       for i  in range (N) :  t[i] = 1 + 0.5 * np.cos(math.pi * (2 * i + 1) / (2 * N)); 
    else:  print("********Lagranzo :  neteisingas parametro kitimo budas"); 
    SpausdintiMatrica(t,T,"t");
    print(t.shape)

    SpausdintiMatrica(X,T,"X")
    SpausdintiMatrica(Y,T,"Y")

    ttt=np.linspace(t[0],t[N-1],nVizPoints);
    Fx=np.zeros(ttt.shape);  Fy=np.zeros(ttt.shape);
    
    if iReplot == False:
       fig3=plt.figure(3,figsize=plt.figaspect(0.5)); ax=fig3.add_subplot(1, 1, 1);ax.set_xlabel('t',fontsize=14);ax.set_ylabel('L',fontsize=14);ax.grid(color='k', linestyle='-', linewidth=0.5)
       plt.plot(t,np.zeros((N)),'mo');
            
       plt.draw();plt.pause(1);
       T.insert(END,ax.lines);T.update()
       
       #del ax.lines[0]
       print(len(ax.lines))
    for i in range(0,N):
        LLL=LagranzoDaugianaris(t,i,ttt);
        print(type(LLL))
        Fx=Fx+LLL*X[i]; Fy=Fy+LLL*Y[i];
        if iReplot == False: 
            rgb=jetColormapValueToRGB(double(i/(N-1)));
            # print(i); print(rgb);
            plt.plot(ttt,LLL,color=rgb,label=('L'+str(i+1))); plt.legend(fontsize=14);
            plt.draw();plt.pause(1);
    if iReplot == False: plt.title("Lagranzo funkcijos",fontsize=12);

    if iReplot == False: print(len(ax.lines));
    #plt.pause(2);
    #ax.lines.remove (line)
    #del ax.lines[1]
    SpausdintiMatrica(Fx,T,"Fx")
    SpausdintiMatrica(Fy,T,"Fy")
    return t,ttt,Fx,Fy
    

#----------------------------------

T=ScrollTextBox(100,20) # sukurti teksto isvedimo langa
T.insert(tk.END,"Lagranzo interpoliavimas\n");
N=5  # interpoliavimo mazgu skaicius
X=np.array([0 , 1, 1, 0, 0],  dtype=np.double);  SpausdintiMatrica(X,T,"X");  # mazgu koordinates
Y=np.array([0 , 0, 1, 1, 0.2],dtype=np.double);  SpausdintiMatrica(Y,T,"Y");
t=np.array([1 , 2 ,6,7,10],    dtype=np.double);  SpausdintiMatrica(t,T,"t"); # parametro reiksmes, jeigu duotos laisvai
T.update();

tt,ttt,Fx,Fy=LagranzoCore( X, Y ,t , 30, "duotosLaisvai", False,T);

# braizomos priklausomybes X(t),  Y(t):
fig1=plt.figure(1,figsize=plt.figaspect(0.5));ax1=fig1.add_subplot(1, 1, 1);ax1.set_xlabel('t',fontsize=14);ax1.set_ylabel('x,y',fontsize=14);ax1.grid(color='k', linestyle='-', linewidth=0.5)
xt,=ax1.plot(ttt,Fx,'b'); xtP,=ax1.plot(tt,X,'bo'); yt,=ax1.plot(ttt,Fy,'r'); ytP,=ax1.plot(tt,Y,'ro'); plt.draw(); plt.pause(1);

# braizoma priklausomybe Y(X):
xmin=min(Fx);ymin=min(Fy);xmax=max(Fx);ymax=max(Fy);
fig2=plt.figure(2,figsize=plt.figaspect((ymax-ymin)/(xmax-xmin))); ax2=fig2.add_subplot(1, 1, 1);ax2.set_xlabel('x',fontsize=14);ax2.set_ylabel('y',fontsize=14);ax2.grid(color='k', linestyle='-', linewidth=0.5)
yxP,=ax2.plot(X,Y,'bo'); yx,=ax2.plot(Fx,Fy,'b',label="duotosLaisvai"); plt.legend(fontsize=14); plt.draw(); plt.pause(1);

#ax2.lines.remove(yxP);
#ax2.properties()['children'][0].set_color('red')  # pakeicia buvusiu grafiku savybes (cia spalvas)

tt,ttt,Fx,Fy=LagranzoCore( X, Y ,t , 30, "aritmetineProgresija", True,T)
yxP,=ax2.plot(X,Y,'co'); yx,=ax2.plot(Fx,Fy,'c',label="aritmetineProgresija"); plt.legend(fontsize=14); plt.draw();plt.pause(1);

tt,ttt,Fx,Fy=LagranzoCore( X, Y ,t , 30, "Ciobysevo", True,T);
yxP,=ax2.plot(X,Y,'ro'); yx,=ax2.plot(Fx,Fy,'r',label="Ciobysevo"); plt.legend(fontsize=14); plt.draw();#plt.pause(1);
 
plt.show();

#
#*******************  Programa ************************************ 
#