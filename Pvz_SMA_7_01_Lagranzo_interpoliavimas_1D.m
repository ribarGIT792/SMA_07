% Pvz_SMA_7_01_Lagranzo_interpoliavimas_1D

function pagrindine
clc,close all
% X=[0  1  2.5 ]
% Y=[0 4 -2 ]
% X=[0  1  2.5  3  6]
% Y=[0 4 -2 -3  6]
X=[0  0.2  3  4  9  10.5  14 14.5]
Y=[0.2 1 1.2 3  3  1.2  1  0.2]
x=min(X):(max(X)-min(X))/100:max(X);

n=length(X)
figure(1), hold on, grid on , axis equal
spalvos=['b','r','g','c','m','k','b','r','g','c','m','k'];
leg={'interpoliavimo mazgai'};
for i=1:n, plot(X(i),Y(i),[spalvos(i),'o'],'MarkerFaceColor',spalvos(i),'MarkerSize',8); end
legend(leg)
pause


F=0;
leg={'interpoliavimo mazgai'};
leg={};
for j=1:n
    L=Lagranzo_daugianaris(X,j,x);
    F=F+L*Y(j);
    plot(x,L,[spalvos(j),'-'],'LineWidth',2);
    leg={leg{:},sprintf('L%d',j)};
    legend(leg);
    pause
end

plot(x,F,'b-','LineWidth',3)
leg={leg{:},'interpoliuojanti kreive'};legend(leg)
% plot(X,Y,'ro')
return
end

function L=Lagranzo_daugianaris(X,j,x)
n=length(X);
L=1;
for k=1:n, if k ~= j, L=L.*(x-X(k))/(X(j)-X(k)); end, end
    % daugianario reiksmes apskaiciuojamos visuose vaizdavimo taskuose,
    % kuriu abscises yra masyve x
return
end