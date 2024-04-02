alarm[0]=1;
alpha-=0.05;
if alpha<=0 {alarm[0]=-1; alarm[1]=room_speed*0.8}