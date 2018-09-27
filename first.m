tic

data = xlsread('CUMCM.xlsx','¸½¼þ2');
U_r = data(:,2);
data = xlsread('CUMCM.xlsx','¸½¼þ1');
kappa = data(:,3);
step_t = 0.001;
step_x = 0.0002;
c_material = data(:,5);
c_discrete = horzcat(...
    ones(1,3-1)*c_material(1),...
    (c_material(1)+c_material(2))/2,...
    ones(1,30-1)*c_material(2),...
    (c_material(2)+c_material(3))/2,...
    ones(1,18-1)*c_material(3),...
    (c_material(3)+c_material(4))/2,...
    ones(1,25-1)*c_material(4)...
    );
time_TT = 5400;
t_raw = 0:time_TT;
U_r1 = U_r(1:time_TT+1);
t = 0:step_t:time_TT;
U_r1 = interp1(t_raw,U_r1,t);
U = zeros(int64(time_TT/step_t)+1,77);
U(:,1) = ones(1,int64(time_TT/step_t)+1)*75;
U(1,2:76)=37;
U(:,77) = U_r1;
for i=1:time_TT/step_t
    temp = U(i,3:77) + U(i,1:75) - U(i,2:76)*2;
    id_temp = find(temp<0);
    temp(id_temp) = 0;
    U(i+1,2:76) = U(i,2:76) + c_discrete.*step_t./(step_x*step_x).*temp;
    U(i+1,[4,34,52]) = [(kappa(2)*U(i+1,3)+kappa(1)*U(i+1,5))/(kappa(2)+kappa(1)),...
        (kappa(3)*U(i+1,33)+kappa(2)*U(i+1,35))/(kappa(3)+kappa(2)),...
        (kappa(4)*U(i+1,51)+kappa(3)*U(i+1,53))/(kappa(4)+kappa(3))
        ];
end

x = (1:77)*0.2;
y = 0:time_TT;
U = U(y*1000+1,:);
[X,Y] = meshgrid(x,y);
figure
mesh(X,Y,U)

%save('U_x_t.mat','U')

toc
