%%Trajectory generation


mdl_puma560
%CIRCLE
radius=0.2;
res=100;
gran=linspace(0,2*pi,res)
x=radius*cos(gran)+0.452
y=radius*sin(gran)-0.150
%plot(y,x)
for i=1:1:res
    TTc(:,:,i)=transl([x(i) y(i) 0.25]);
end
qq=ikine6s(p560,TTc);

qq(:,4)=0;
qq(:,5)=0;
qq(:,6)=0;

plot(p560,qq)

%signal for simulink

tfin=2;
timegran=size(qq);
timestep=timegran(1);
t=linspace(0,tfin,timestep);
qqs=[t' qq];

qqs(:,6) = pi/4;
