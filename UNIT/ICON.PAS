Unit Icon;

Interface
 Type
  MasIcon16 = array [0..15,0..7] of byte;
  MasIcon8 = array [0..7,0..3] of byte;
 Const
  Icon8_1 : MasIcon8 =(
       ($00,$00,$00,$00),
       ($70,$00,$00,$07),
       ($77,$00,$00,$77),
       ($77,$70,$07,$77),
       ($77,$77,$77,$77),
       ($77,$77,$77,$77),
       ($77,$77,$77,$77),
       ($77,$77,$77,$77));
  Icon8_2 : MasIcon8 =(
       ($00,$77,$77,$00),
       ($00,$07,$70,$00),
       ($70,$00,$00,$07),
       ($77,$00,$00,$77),
       ($77,$00,$00,$77),
       ($70,$00,$00,$07),
       ($00,$07,$70,$00),
       ($00,$77,$77,$00));

 Procedure OutPutIcon16(x,y:word;Var Ic:MasIcon16);
 Procedure OutPutIcon8(x,y:word;Var Ic:MasIcon8);
 Procedure CreateIcon(x,y:word;name:string;Lx,Ly:byte);
Implementation
 Uses Graph;

 Procedure OutputIcon16;
 Var
  i,j:word;
  pr,nx : byte;
 Begin
  for i:=0 to 15 do
      for j:=0 to 7 do
          begin
           pr:=Ic[i,j] div 16;
           nx:=Ic[i,j] mod 16;
           putpixel(x+2*j,y+i,pr);
           putpixel(x+2*j+1,y+i,nx);
          end;
 End;
 Procedure OutputIcon8;
 Var
  i,j:word;
  pr,nx : byte;
 Begin
  for i:=0 to 7 do
      for j:=0 to 3 do
          begin
           pr:=Ic[i,j] div 16;
           nx:=Ic[i,j] mod 16;
           putpixel(x+2*j,y+i,pr);
           putpixel(x+2*j+1,y+i,nx);
          end;
 End;
 Procedure CreateIcon;
 Var
  f:text;
  i,j:word;
  pr,nx : byte;
  s : string;
  Function hexdec(kol:byte):string;
  Var
   sk:string;
  Begin
   Case kol of
        0..9:str(kol,sk);
        10:sk:='A';
        11:sk:='B';
        12:sk:='C';
        13:sk:='D';
        14:sk:='E';
        15:sk:='F';
   End;
   Hexdec:=sk;
  End;
 Begin
  Assign(f,name);
  rewrite(f);
  writeln(f,'  Icon : MasIcon =(');
  for i:=0 to Ly-1 do
      begin
       write(f,'       (');
       for j:=0 to Lx-1 do
           begin
            nx:=getpixel(x+j,y+i);
            if (((j+1) mod 2) = 0) then
               begin
                s:='$'+hexdec(pr)+hexdec(nx);
                write(f,s);
                if j <> Lx-1 then write(f,',');
               end;
            pr:=nx;
           end;
       write(f,')');
       if i <> Ly-1
          then writeln(f,',')
          else writeln(f,');');
      end;
  close(f);
 End;
End.