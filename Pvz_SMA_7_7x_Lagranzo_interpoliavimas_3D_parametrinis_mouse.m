% Lagranzo_interpoliavimas_parametrinis_3D
% Pele valdomos interpoliavimo tasku padetys

function main
clc,close all,clear all 
hL=[]; % busimu objektu valdikliu masyvas
f=figure; hold on; grid on

X=[-1  1  1  -1 -1 ]
Y=[ 1  1 -1  -1  1 ]
Z=[ 1  -1 1  -1  1 ]
nP=length(X);

if 1      % parametru reiksmes yra atstumai tarp interpoliavimo tasku
    t(1)=0; for i=2:nP, t(i)=t(i-1)+norm([X(i) Y(i) Z(i)]-[X(i-1) Y(i-1) Z(i-1)]); end
else
    t=[ 0  1  2   3  4 ]; % parametru reiksmes priskiriamos laisvai    
end
t


NN=200;
ttt=[min(t):(max(t)-min(t))/NN:max(t)];

figure(1);axis([-3,3,-3,3,-3,3]);axis equal;hold on;

% vaizduojame duotus taskus
for i=1:nP, h(i)=plot3(X(i), Y(i), Z(i),'ko','MarkerFaceColor','k',...
        'ButtonDownFcn',@startDragFcn,'MarkerSize',10); end
    % tasku objektu valdikliai issaugomi masyve h;
    % funkcijoje startDragFcn nurodoma, ka reikia atlikti, kai peles
    % klavisa paspaudziame jai esant ties sukurtu grafiniu objektu h(i) 

set(f,'WindowButtonUpFcn',@stopDragFcn); % funkcijoje stopDragFcn nurodoma, ka reikia  atlikti,
                                         % kai atleidziame peles klavisa  
Lagranzo_parametrinis_interpoliavimas(X,Y,Z,t,ttt);  % interpoliuojame pagal ivestus taskus ir 
                                                     % nubraizome pradine kreive  
                                                   
%************************************************************************   
% Toliau programa laukia pertraukimo nuo peles klaviso, kuris inicijuja 
% startDragFcn arba stopDragFcn vykdyma. Jos savo ruoztu peles judesi susieja arba atsieja 
% su draggingFcn
%************************************************************************
                                                   
%-----------  vidines funkcijos ------------------
%  jos aprasomos anksciau, nei sutinkamas pagrindines funkcijos "end",
%  todel visi pagrindineje funkcijoje naudojami kintamieji matomi taip pat
%  ir vidinese funkcijose

function startDragFcn(varargin)  % apraso, kas atliekama, kai paspaudziamas kairys peles klavisas
    set(gcf, 'WindowButtonMotionFcn',@draggingFcn); % nurodo funkcija, kuria reikia nuolat kviesti pelei judant
end

function draggingFcn(varargin)   % apraso, kas atliekama, kai pakinta pele valdomo objekto padetis
    pt=get(gca,'Currentpoint');  % perskaitoma peles padetis
    % nustatome su kuriuo valdikliu susieta objekta judiname ir prisimename buvusias koordinates x,y,z:
        x=X(find(gco == h));y=Y(find(gco == h));z=Z(find(gco == h));
    % nuskaitome koord.sistemos orientacija ir vaizdo plokstumos orientacija GKS.
    % vaizdo plokstumoje judinamas taskas turi islikti vaizdo plokstumai lygiagrecioje plokstumoje, 
    % kurioje jis pradejo judeti:
         [az,el]=view; az=az*pi/180;el=el*pi/180;
         
        T1=[cos(-az) ,   -sin(-az) ,    0    ;
            sin(-az) ,    cos(-az) ,    0    ;
              0      ,       0     ,    1    ];
          
        T2=[  1      ,       0     ,    0    ; 
              0      ,    cos(el)  , -sin(el);
              0      ,    sin(el)  ,  cos(el)];
          
        n=T1'*T2'*[0; -1; 0]; % vaizdo plokstumos normale GKS 
        a=pt(1,:)-[x y z]; % vektorius, kuriuo pajudejo taskas 
        ptn(1,1:3)=pt(1,:)-n'*dot(n,a); % pajudinto tasko projekcija vaizdui lygiagrecioje plokstumoje, 
                                        % kurioje jis buvo pries pajudinima
        set(gco,'xData',ptn(1,1),'yData',ptn(1,2),'zData',ptn(1,3)); % pakeiciamos tasko koordinates   
     % prisimename tasko koordinates mazyvuose X,Y,Z:
        X(find(gco == h))=ptn(1,1);  Y(find(gco == h))=ptn(1,2); Z(find(gco == h))=ptn(1,3);
        Lagranzo_parametrinis_interpoliavimas(X,Y,Z,t,ttt);
end

function stopDragFcn(varargin) % apraso, kas atliekama, kai atleidziamas kairys peles klavisas
    set(gcf, 'WindowButtonMotionFcn','');% nurodo, kad atleidus peles klavisa peles judejimas nebeturi kviesti funkcijos
end

function Lagranzo_parametrinis_interpoliavimas(X,Y,Z,t,ttt)
    n=length(X);
    FX=0;FY=0;FZ=0;
    for j=1:n
        L=Lagranzo_polinomas(t,n,j,ttt);
        FX=FX+L*X(j); FY=FY+L*Y(j); FZ=FZ+L*Z(j);
    end
    if ~isempty(hL), delete(hL); end
    hL=plot3(FX,FY,FZ,'b-');
return
end

function L=Lagranzo_polinomas(X,n,j,x)
    L=1;
    for k=1:n, if k ~= j, L=L.*(x-X(k))/(X(j)-X(k)); end, end
        % polinomo reiksmes apskaiciuojamos kiekviename braizymo taske,
        % pagal masyvo x koordinates:
return
end

end   % Sis end uzbaigia pagrindine funkcija