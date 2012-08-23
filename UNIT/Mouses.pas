Unit mouses;

Interface

 Var
  TimeUp:word;

 Function InitMouse(Var button:byte):boolean;

 Function CrtMs(x:word):byte;

 Procedure ShowCrMs;

 Procedure HideCrMs;

 Procedure InCrMs;

 Function OprCrMS:boolean;

 Procedure StatusMs(Var button:byte;Var x,y:word);

 {1-left button,2-rigt button,3-left and rigt button,4-double left click,5-double rigt click}
 Procedure ClickMouse(Var button:byte;Var x,y:word);

 Procedure GotoXYMs(x,y:word);

 Procedure PressButtonMs(Var button:byte;Var x,y,Count:word);

 Procedure ReleaseButtonMs(Var button:byte;Var x,y,Count:word);

 Procedure LimitXCr(xmin,xmax:word);

 Procedure LimitYCr(ymin,ymax:word);

 Procedure SetTextCrMs(ScrenMask,CursorMask:word);

 Procedure SetGraphCrMs(ActivX,ActivY:Integer;address:pointer);

 Procedure MoveCrMs(Var x,y:Integer);

 Function SizeDrv:word;

 Procedure SaveDrv(address:pointer);

 Procedure RestoreDrv(address:pointer);

Implementation

 Uses tpcrt,dos;

 Var

  regs:registers;
  VidCr:boolean;

 Function InitMouse(Var button:byte):boolean;
 Begin
  regs.AX:=$00;
  Intr($33,regs);
  button:=regs.BX;
  InitMouse:=odd(regs.AX);
{  HideCrMs;}
 End;

 Procedure ShowCrMs;
 Begin
  regs.AX:=$01;
  Intr($33,regs);
  VidCr:=True;
 End;

 Procedure HideCrMs;
 Begin
  regs.AX:=$02;
  Intr($33,regs);
  VidCr:=false;
 End;

 Procedure InCrMs;
 Begin
  Case VidCr of
       True  :
       HideCrMs;
       False :
       ShowCrMs;
  End;
 End;

 Function OprCrMs;
 Begin
  OprCrMs:=VidCr;
 End;

 Procedure StatusMs;
 Begin
  regs.AX:=$03;
  intr($33,regs);
  with regs do
       begin
        button:=BL;
        x:=CX;
        y:=DX;
       end;
 End;

 Procedure ClickMouse;
 Var
  x1,y1,io:word;
  tmp:byte;
 Begin
  StatusMs(button,x,y);
  if button in [1,2]
     then
     begin
       io:=0;
       repeat
        if keypressed
           then
           begin
            button:=0;
            exit;
           end;
        if io > TimeUp then exit;
        inc(io);
        delay(1);
        StatusMs(tmp,x1,y1)
       until tmp = 0;
       io:=0;
       repeat
        if keypressed
           then
           begin
            button:=0;
            exit;
           end;
        if io > TimeUp then exit;
        inc(io);
        delay(1);
        StatusMs(tmp,x1,y1)
       until tmp = button;
       io:=0;
       repeat
        if keypressed
           then
           begin
            button:=0;
            exit;
           end;
        if io > TimeUp then exit;
        inc(io);
        delay(1);
        StatusMs(tmp,x1,y1);
       until tmp = 0;
       button:=button+3;
     end;
 End;

 Procedure GotoXYMs;
 Begin
  with regs do
       begin
        AX:=$04;
        CX:=x;
        DX:=y;
       end;
  intr($33,regs);
 End;

 Procedure PressButtonMs;
 Begin
  regs.AX:=$05;
  regs.BL:=button;
  intr($33,regs);
  with regs do
       begin
        button:=AL;
        count:=BX;
        x:=CX;
        y:=DX;
       end;
 End;

 Procedure ReleaseButtonMs;
 Begin
  regs.AX:=$06;
  regs.BL:=button;
  intr($33,regs);
  with regs do
       begin
        button:=AL;
        count:=BX;
        x:=CX;
        y:=DX;
       end;
 End;

 Procedure LimitXCr;
 Begin
  with regs do
       begin
        AX:=$07;
        CX:=xmin;
        DX:=xmax;
       end;
  intr($33,regs);
 End;

 Procedure LimitYCr;
 Begin
  with regs do
       begin
        AX:=$08;
        CX:=ymin;
        DX:=ymax;
       end;
  intr($33,regs);
 End;

 Procedure SetTextCrMs;
 Begin
  with regs do
       begin
        AX:=$0A;
        BX:=$00;
        CX:=ScrenMask;
        DX:=CursorMask;
       end;
  intr($33,regs);
 End;

 Procedure SetGraphCrMs;
 Begin
  with regs do
       begin
        AX:=$09;
        BX:=word(ActivX);
        CX:=word(ActivY);
        ES:=Seg(address^);
        DX:=Ofs(address^);
       end;
  intr($33,regs);
 End;

 Procedure MoveCrMs;
 Begin
  regs.AX:=$0B;
  intr($33,regs);
  x:=Integer(regs.CX);
  y:=Integer(regs.DX);
 End;

 Function SizeDrv;
 Begin
  regs.AX:=$15;
  intr($33,regs);
  SizeDrv:=regs.BX;
 End;

 Procedure SaveDrv;
 Begin
  with regs do
       begin
        AX:=$16;
        ES:=seg(address^);
        DX:=ofs(address^);
       end;
  intr($33,regs);
 End;

 Procedure RestoreDrv;
 Begin
  with regs do
       begin
        AX:=$17;
        ES:=seg(address^);
        DX:=ofs(address^);
       end;
  intr($33,regs);
 End;

 Function OprPageMs:word;
 Begin
  regs.AX:=$1E;
  intr($33,regs);
  OprPageMs:=regs.BX;
 End;

 Procedure SetPageMs(page:word);
 Begin
  regs.AX:=$1D;
  regs.BX:=page;
  intr($33,regs);
 End;

 Function MouseSoftware(Var button:word):boolean;
 Begin
  regs.AX:=$21;
  intr($33,regs);
  button:=regs.BX;
  MouseSoftware:=regs.AX = $FFFF;
 End;

 Function CrtMs(x:word):byte;
 Begin
  CrtMs:=1+x div 8;
 End;

Begin
 TimeUp:=9999;
 VidCr:=false;
End.

