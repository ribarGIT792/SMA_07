close all
n=6
fg=figure(1),hold on,grid on
set(fg,'Color','w')

j=0:n-1
plot(j,cos(pi*(2*j+1)/(2*n)),'r*')
jj=0:0.01:n-1
plot(jj,cos(pi*(2*jj+1)/(2*n)),'r-.')


plot(j*0,cos(pi*(2*j+1)/(2*n)),'bo','MarkerSize',8,'MarkerFaceColor','b')

for i=j
     plot([0,i],[1,1]*cos(pi*(2*i+1)/(2*n)),'b-.')
end
xlabel('i');
ylabel('x');
title(sprintf('tasku skaicius  n=%d',n))
