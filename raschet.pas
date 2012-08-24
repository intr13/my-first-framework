Unit Raschet;
Interface
Type
 Mas_A = array [0..8,0..8] of real;
 Mas_B = array [0..8] of real;
Var
 A         : Mas_A;
 B         : Mas_B;
 X         : Mas_B;
 Razmer    : 2..9;
 Procedure InizMatr;
 Procedure RunRaschet;
 Procedure PrintRaschet(kak:byte);
Implementation
Uses graph,opengrap;
Var
 Ar        : Mas_A;
 Br        : Mas_B;
 Temp      : Mas_B;
 Smesh     : byte;
 i,j,k     : byte;
 Max,tm    : real;

 Procedure InizMatr;
 Begin
  razmer:=3;
  A[0,0]:=13;
  A[0,1]:=21;
  A[0,2]:=3;
  A[1,0]:=33;
  A[1,1]:=4;
  A[1,2]:=56;
  A[2,0]:=63;
  A[2,1]:=1;
  A[2,2]:=4;
  B[0]:=0;
  B[1]:=12;
  B[2]:=3;
 End;
 Procedure printRaschet;
 Var
  s,s2:string;
 Begin
  BarShadow(10,30,630,440,true,7);
  setcolor(0);
  outtextxy(20,35,'Вывод тpеугольной матpицы');
  outtextxy(20,360,'Вывод pезультата');
  for i:=0 to razmer-1 do
      begin
       for j:=0 to razmer-1 do
           begin
            if kak = 0
               then s:='0'
               else str(Ar[i,j]:6:3,s);
            outtextxy(20+j*50,50+i*10,s);
           end;
       if kak = 0
          then s:='0'
          else str(Br[i]:6:3,s);
       outtextxy(35+razmer*50,50+i*10,s);
       if kak = 0
          then s:='0'
          else str(X[i]:6:3,s);
       str(i,s2);
       s:='X'+s2+'='+s;
       outtextxy(35+i*80,375,s);
      end;
 End;
 Procedure Poisk;
 Begin
  j:=smesh;
  max:=Ar[smesh,smesh];
  for i:=smesh+1 to Razmer-1 do
      if abs(Ar[i,smesh]) > abs(Ar[j,smesh]) then j:=i;
  if Ar[j,smesh] = 0
     then
      halt(1);
  if j <> smesh then
     begin
      for i:=smesh to Razmer-1 do
          begin
           max:=Ar[smesh,i];
           Ar[smesh,i]:=Ar[j,i];
           Ar[j,i]:=max;
          end;
      max:=Br[smesh];
      Br[smesh]:=Br[j];
      Br[j]:=max;
     end;
 End;
 Procedure DivStrocElem;
 Begin
  Max:=Ar[smesh,smesh];
  for j:=smesh to Razmer-1 do
       Ar[smesh,j]:=Ar[smesh,j]/max;
  Br[smesh]:=Br[smesh]/max;
 End;
 Procedure UmnjStrocElem(UmnjElem:real);
 Begin
  for j:=smesh to Razmer-1 do
       Temp[j]:=Ar[smesh,j]*UmnjElem;
  Max:=Br[smesh]*UmnjElem;
 End;
 Procedure SummStrocElem(NomerStroc:byte);
 Begin
  for j:=smesh to Razmer-1 do
       Ar[NomerStroc,j]:=Ar[NomerStroc,j]-Temp[j];
  Br[NomerStroc]:=Br[NomerStroc]-max;
 End;
 Function MnojStrocElem:real;
 Var
  t:real;
 Begin
  t:=0;
  if smesh = Razmer-1 then
     begin
      MnojStrocElem:=Br[smesh];
      exit;
     end;
  for j:=Razmer-1 downto smesh+1 do
       t:=Ar[smesh,j]*X[j]+t;
  t:=Br[smesh]-t;
  MnojStrocElem:=t;
 End;
 Procedure RunRaschet;
 Begin
  Ar:=A;
  Br:=B;
  for smesh:=0 to Razmer-1 do
      begin
       poisk;
       DivStrocElem;
       for i:=Smesh+1 to Razmer-1 do
           begin
            UmnjStrocElem(Ar[i,smesh]);
            SummStrocElem(i);
           end;
      end;
  for smesh:=Razmer-1 downto 0 do
      begin
       X[smesh]:=MnojStrocElem;
      end;
 End;
End.