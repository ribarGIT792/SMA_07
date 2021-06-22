% Parametrinis funkcijos vaizdavimas 

function pagrindine
clc,close all

syms fx fy t

fx='3*sin(2*t)';
fy='6*cos(2*t)'
% 
fx='2*sin(2*t)';
fy='3*cos(3*t)^2';

fx='2*(1-0.1*t)*sin(t)';
fy='3*(1-0.1*t)*cos(t)'; 
% 
% fx='2*sin(t)';
% fy='3*sin(2*t)';

% fx='sqrt(t)';
% fy='3*cos(3*t)';

% fy=sqrt(t);
% fx=tan(t);

% fx='t';
% fy='(t-2)^2';

% fx='2*sin(t)+0.2*sin(5*t)';
% fy='2*cos(t)+0.2*sin(5*t)';
% 
% fx='2*sin(t)+0.2*sin(5*t)';
% fy='2*sin(t-pi/2)+0.2*sin(5*(t-pi/2))';


xshift=5;yshift=5;
T=[0:0.05:10];N=length(T);
figure(1);axis equal;axis([-5 15 -5 15]);hold on;grid on
h=[];
for i=1:N
    t=T(i);
    FX=eval(fx); FY=eval(fy);
    plot(T(i)+xshift,FY,'b.'); 
    plot(FX,T(i)+yshift,'r.'); 
    plot(FX,FY,'m.'); 
   
    if ~isempty(h),delete(h);end
    h(1)=plot(FX,FY,'c*','Markersize',8);
    h(2)=plot([xshift+T(i),FX],[FY,FY],'b-');
    h(3)=plot([FX,FX],[yshift+T(i),FY],'b-');
    pause(0.026)
end

return
end