
% Objektu padeties valdymas pele

function main
clc,close all,clear all 
f=figure(1); hold on; grid on; axis equal;

X=[-1  0.5  1  1  -1  ]
Y=[ 1  0.5 1 -1  -1  ]
nP=length(X);

% vaizduojame duotus mazgus, kiekvieno objekto valdikli susiejame su funkcija PradetiVilkti:
for i=1:nP, h(i)=plot(X(i), Y(i),'ko','MarkerFaceColor','k',...
        'ButtonDownFcn',@PradetiVilkti,'MarkerSize',10); end

set(f,'WindowButtonUpFcn',@BaigtiVilkti); % kas atliekama atleidus peles klavisa, nurodoma funkcijoje BaigtiVilkti

%-------------------------------------------------
%-----------  vidines funkcijos ------------------
%-------------------------------------------------

    function PradetiVilkti(varargin)  % apraso, kas atliekama, kai paspaudziamas kairys peles klavisas
        fprintf(1,'L A B A S, M A Z G E  NR. %d  !  \n',find(gco==h));
        set(gcf, 'WindowButtonMotionFcn',@Vilkti); % nurodo funkcija, kuria reiks nuolat kviesti pelei judant
        return
    end

    function Vilkti(varargin)  % apraso, kas atliekama, kai pele juda
        pt=get(gca,'Currentpoint');  % perskaitoma peles padetis
        set(gco,'xData',pt(1,1),'yData',pt(1,2)); % pakeiciamos objekto koordinates
        fprintf(1,'x= %g  y= %g !  \n',pt(1,1:2));
        return
    end

    function BaigtiVilkti(varargin) % apraso, kas atliekama, kai atleidziamas kairys peles klavisas
        set(gcf, 'WindowButtonMotionFcn','');% nurodo, kad atleidus peles klavisa peles judejimas nebeturi kviesti funkcijos
        if  gco ~= gca ,fprintf(1,'V I S O  G E R O, M A Z G E  NR. %d  ! \n\n\n',find(gco==h)); end
        return
    end

%-------------------------------------------------
%----------- vidiniu funkciju pabaiga ------------
%-------------------------------------------------


end   % Sis end uzbaigia pagrindine funkcija