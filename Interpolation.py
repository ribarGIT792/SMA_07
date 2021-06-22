import numpy as np
from numpy import *
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from DraggablePoint import DraggablePoint

class Interpolation:
    
    h1=[];h2=[];  # klases kintamieji, kreives ir mazgu markeriu sekos valdikliai. Naudojami kreives naikinimui.
  
    def __init__(self, interpolationMode,parametroKitimas,t):   # instance konstruktorius
        self.interpolationMode=interpolationMode;  # interpoliavimo metodas 
        self.parametroKitimas=parametroKitimas; # parametro kitimo desnis 
        self.t=t;  # parametro reiksmes(jeigu reikia ivesti)
        print("Interpolation instance:  interpolationMode= %s" % self.interpolationMode)

    def interpolatedCurve(self,x,y,ax): # iejimo kintamieji turi buti tik mazgu koodrdinaciu sarasai ir asiu identifikatorius:
        self.h1=[];self.h2=[]; 
        if self.interpolationMode == "brokenLine":
            self.h1,=ax.plot(x,y,"b-");
            self.h2,=ax.plot(x,y,color='green',marker='o',markersize=12,linestyle='None');
        elif self.interpolationMode == "LagrangianLine": 
            Fx,Fy=self.LagranzoCore(x, y, ax);
            self.h1,=ax.plot(Fx,Fy,"b-");  # interpoliuota kreive
            self.h2,=ax.plot(x,y,color='green',marker='o',markersize=12,linestyle='None'); # markeriai
        else:  print ("neteisinga interpolationMode reiksme:  %s" %self.interpolationMode)

    #-------- Lagranzo daugianaris -------------
    def LagranzoDaugianaris(self,X,j,xxx):
        N=size(X);
        L=np.ones(xxx.shape,  dtype=np.double);
        for k in range(0,N) :
            if (j != k):  L=L*((xxx - X[k]) / (X[j] - X[k]))
        return L 
    #----------------------------------

    #-------- Lagranzo interpoliavimo funkcija -------------
    def LagranzoCore(self, X, Y, ax):
        nVizPoints=300;
        N=size(X);
        if self.parametroKitimas == "aritmetineProgresija" :
           self.t=np.zeros(N); 
           for i  in range (N) :  self.t[i] = i;
        elif self.parametroKitimas == "Ciobysevo" :
           self.t=np.zeros(N); 
           for i  in range (N) :  self.t[i] = 1 + 0.5 * np.cos(math.pi * (2 * i + 1) / (2 * N)); 
        elif self.parametroKitimas == "duotaLaisvai" : self.t;
        else:  print("********Lagranzo :  neteisingas parametro kitimo budas"); 

        ttt=np.linspace(self.t[0],self.t[N-1],nVizPoints);
        Fx=np.zeros(ttt.shape);  Fy=np.zeros(ttt.shape);
    
        for i in range(0,N):
            LLL=self.LagranzoDaugianaris(self.t,i,ttt);
            Fx=Fx+LLL*X[i]; Fy=Fy+LLL*Y[i];

        return Fx,Fy
    
#---------------------------------- 