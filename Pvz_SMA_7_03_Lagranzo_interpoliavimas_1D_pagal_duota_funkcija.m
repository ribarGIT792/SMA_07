% Lagranzo_interpoliavimas_1D_pagal_duota_funkcija
% Programa demonstruoja, kaip skiriasi interpoliavimo kokybe, 
% kai interpoliavimui parenkame N ir N+1 tolygiai paskirstytu tasku 

function pagrindine
clc,close all

xmin=-2;xmax=3;  % duotas funkcijos apibrezimo intervalas 
N=3;   % interpoliavimo tasku skaicius
N1=N+1;
X=[xmin:(xmax-xmin)/(N-1):xmax];  % tolygiai paskirstytu interpoliavimo tasku abscises
X1=[xmin:(xmax-xmin)/(N1-1):xmax];  % tolygiai paskirstytu interpoliavimo tasku abscises

leg={'duota funkcija',...
    sprintf('interpoliavimas per tolygiai isdestytus %d mazg.',N),...
    '',...
    sprintf('netiktis interpoliuojant per tolygiai isdestytus %d mazg.',N),...
    sprintf('interpoliavimas per tolygiai isdestytus %d mazg. ',N1),...
    '',...
    sprintf('netiktis interpoliuojant per tolygiai isdestytus %d mazg.',N1),...
    'netiktis sulyginant du skirtingu eiliu interpoliavimus'}

Y=funkcija(X);     %  tolygiai paskirstytu interpoliavimo tasku ordinates
Y1=funkcija(X1);   %  
x=min(X):(max(X)-min(X))/1000:max(X);   %x reiksmes vaizdavimui

figure(1), hold on, grid on,axis equal 
plot(x,funkcija(x),'b-')   % pavaizduojama duotoji funkcija (t.y. pagal kuria interpoliuojama) 
hg=legend(leg{1});pause

F=0;F1=0;
for j=1:N
    L=Lagranzo_daugianaris(X,j,x);  % Lagranzo daugianariai pagal tolygiai paskirstytas abscises
    F=F+L*Y(j);                     % kaupiamos sumos interpoliuojanciu funkciju vaizdavimui
end
for j=1:N1
    L1=Lagranzo_daugianaris(X1,j,x);  % Lagranzo daugianariaipagal tolygiai paskirstytas abscises
    F1=F1+L1*Y1(j);                     % kaupiamos sumos interpoliuojanciu funkciju vaizdavimui
end

plot(x,F,'r-'),plot(X,Y,'ro','MarkerFaceColor','r','MarkerSize',8)      % vaizduojama funkcija, interpoliuojanti tolygiai paskirstytuose N taskuose 
plot(x,funkcija(x)-F,'r--'),       % braizoma liekana  
hg=legend(leg{1:4});pause

plot(x,F1,'c-'),plot(X1,Y1,'co','MarkerFaceColor','c','MarkerSize',8)   % vaizduojama funkcija, interpoliuojanti tolygiai paskirstytuose N+1 taskuose
plot(x,funkcija(x)-F1,'c--')       % vaizduojama liekana  
hg=legend(leg{1:7});pause

plot(x,F1-F,'k-')                   % liekanos ivertis pagal dvi skirtingas interpoliacijas 
hg=legend(leg);
return
end

function L=Lagranzo_daugianaris(X,j,x)
% X - interpoliavimo tasku abscises
% n - interpoliavimo tasku skaicius (daug.laipsnis yra n-1)
% x - abscises, kuriose apskaiciuojama daugianario reiksme
    n=length(X);
    L=1;
    for k=1:n, if k ~= j, L=L.*(x-X(k))/(X(j)-X(k)); end, end
        % polinomo reiksmes apskaiciuojamos kiekviename braizymo taske,
        % pagal masyvo x koordinates:
return
end


function fnk=funkcija(x)
% apskaiciuoja interpoliuojamos funkcijos reiksmes taskuose x

% fnk=sin(5*x)+x.^2/10;
% fnk=exp(-10*x.^2);
fnk=1./(1+3*x.^2);
return
end