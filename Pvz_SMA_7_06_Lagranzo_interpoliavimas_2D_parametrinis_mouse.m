
% Lagranzo_interpoliavimas_2D_parametrinis
% Pele valdomos interpoliavimo mazgu padetys
% Keturi skirtingi parametro reiksmiu sekos varijantai itakoja kreives
% forma. Kai parenkami Ciobysevo mazgai (option=3) kreives ilgis maziausias


function main
clc,clear all 
close all
f=figure(1);axis([-3,3,-3,3]);axis equal;hold on;set(gcf,'Color','w');box on;grid on

hL=[]; % isorineje funkcijoje deklaruojamas objektu valdikliu masyvas bus matomas visose vidinese funkcijose

X=[-1  0  1  1  0 -2 ]
Y=[-1  1  0 -1 -2 -2 ]

nP=length(X);

option=1  % parametru reiksmes yra atstumai tarp interpoliavimo mazgu (b)
option=2  % parametru reiksmes yra aritmetine progresija (r)
option=3  % parametru reiksmes yra Ciobysevo taskai (k)
option=4  % parametru reiksmes parenkamos laisvai  (m)

option=4 
switch option
    case 1, t(1)=0; for i=2:nP, t(i)=t(i-1)+norm([X(i) Y(i)]-[X(i-1) Y(i-1)]); col='b-';str='t yra atstumai tarp mazgu'; end
    case 2, for i=0:nP-1, t(i+1)=-1+i*2/(nP-1); col='r-';str= sprintf('t yra aritmetine progresija');end
    case 3, for i=0:nP-1, t(i+1)=-cos(pi*(2*i+1)/(2*nP));col='k-';str='t yra Ciobysevo taskai'; end
    case 4, t=[ 0 1  8  9  10  19 ]; col='g-';str='t reiksmes parenkamos laisvai';
end
strt=sprintf('  %g ',t);title(sprintf('%s \n %s',str,strt));
t 

NN=200;  % vaizdavimo tasku skaicius
ttt=[min(t):(max(t)-min(t))/NN:max(t)]; %parametro reiksmes vaizdavimo taskuose

figure(1);axis([-3,3,-3,3]);axis equal;hold on;set(gcf,'Color','w');box on;

% vaizduojame duotus mazgus
for i=1:nP, h(i)=plot(X(i), Y(i),'ko','ButtonDownFcn',@startDragFcn,...
                     'MarkerFaceColor','k','MarkerSize',10); 
end
    % kas atliekama paspaudus peles klavisa, nurodoma funkcijoje startDragFcn
    % tasku objektu valdikliai issaugomi masyve h

set(f,'WindowButtonUpFcn',@stopDragFcn); % kas atliekama atleidus peles klavisa, nurodoma funkcijoje stopDragFcn

Lagranzo_parametrinis_interpoliavimas(X,Y,t,ttt);  % interpoliuojame pagal ivestus mazgus ir 
                                                   % nubraizome pradine kreive  
                                                                                              
%************************************************************************   
% Toliau programa laukia pertraukimo nuo peles klaviso, kuris inicijuoja 
% startDragFcn arba stopDragFcn vykdyma. Jos savo ruoztu peles judesi susieja arba atsieja 
% su draggingFcn
%************************************************************************
disp('Baige darba spauskite bet kuri klavisa');
pause
set (h,'ButtonDownFcn','');
delete(h);leg1=get(findobj(gcf,'Tag','legend'));
legtext=[]; if ~isempty(leg1),[a,b,c,legtext]=legend;legend('off'); end
if ~isempty(legtext),leg=legend([legtext, {str}]);
else,leg=legend({str}); 
end 
title('');
                                                   
%-----------  vidines funkcijos ------------------
%  jos aprasomos anksciau, nei sutinkamas pagrindines funkcijos "end",
%  todel visi pagrindineje funkcijoje naudojami kintamieji matomi taip pat
%  ir vidinese funkcijose

function startDragFcn(varargin)  % apraso, kas atliekama, kai paspaudziamas kairys peles klavisas
     set(gcf, 'WindowButtonMotionFcn',@draggingFcn); % nurodo funkcija, kuria reikia nuolat kviesti pelei judant
end

function draggingFcn(varargin)  % apraso, kas atliekama, kai pele juda
    pt=get(gca,'Currentpoint');  % perskaitoma peles padetis
    set(gco,'xData',pt(1,1),'yData',pt(1,2)); % pakeiciamos objekto koordinates
    % nustatome su kuriuo valdikliu susieta objekta judiname, ir pakeiciame to tasko koordinates
    % interpoliavimo tasku masyvuose X ir Y:
    X(find(gco == h))=pt(1,1);  Y(find(gco == h))=pt(1,2);
    % kvieciame savo sukurta funkcija interpoliuojanciai kreivei apskaiciuoti: 
    Lagranzo_parametrinis_interpoliavimas(X,Y,t,ttt);   
end

function stopDragFcn(varargin) % apraso, kas atliekama, kai atleidziamas kairys peles klavisas
    set(gcf, 'WindowButtonMotionFcn','');% nurodo, kad atleidus peles klavisa peles judejimas nebeturi kviesti funkcijos
end

function Lagranzo_parametrinis_interpoliavimas(X,Y,t,ttt)
    n=length(X);
    FX=0;FY=0;
    for j=1:n, L=Lagranzo_daugianaris(t,n,j,ttt); FX=FX+L*X(j); FY=FY+L*Y(j); end
    if ~isempty(hL), delete(hL); end
    hL=plot(FX,FY,col,'LineWidth',2);
return
end

function L=Lagranzo_daugianaris(X,n,j,x)
    L=1;
    for k=1:n, if k ~= j, L=L.*(x-X(k))/(X(j)-X(k)); end, end
        % daugianario reiksmes apskaiciuojamos kiekviename braizymo taske,
        % pagal masyvo x koordinates:
return
end


end   % Sis end uzbaigia pagrindine funkcija