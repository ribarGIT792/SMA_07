% Lagranzo_interpoliavimas_parametrinis 

function pagrindine
clc,close all
X=[-1  1  1  -1 -1 ]
Y=[ 1  1 -1  -1  1.5 ]
n=length(X)

if 1   % parametru reiksmes yra atstumai tarp interpoliavimo tasku
    t(1)=0; for i=2:n, t(i)=t(i-1)+norm([X(i) Y(i)]-[X(i-1) Y(i-1)]); end
else
    t=[ 0  1  2   3   4 ]
%     t=[ 0  1  2   3  40 ]     % parametru reiksmes priskiriamos laisvai  
end
t

ttt=0:0.01:t(end);

figure(1), hold on, grid on, axis equal
plot(X,Y,'ro','MarkerFaceColor','r','MarkerSize',8)

FX=0;FY=0;
for j=1:n
    L=Lagranzo_polinomas(t,n,j,ttt)
    FX=FX+L*X(j);
    FY=FY+L*Y(j);
end
plot(FX,FY,'b-')
legend({'','F(X,Y)=0'})
figure(2), hold on, grid on, axis equal
plot(ttt,FX,'g-'),plot(t,X,'go','MarkerFaceColor','g','MarkerSize',8)
plot(ttt,FY,'m-'),plot(t,Y,'mo','MarkerFaceColor','m','MarkerSize',8)
legend({'X(t)','','Y(t)',''})
return
end

function L=Lagranzo_polinomas(X,n,j,x)
    L=1;
    for k=1:n, if k ~= j, L=L.*(x-X(k))/(X(j)-X(k)); end, end
return
end