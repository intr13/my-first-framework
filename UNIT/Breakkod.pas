Unit BreakKod;
Interface
 Type
  TimeClick = record
            Hour,Min,Sec,Hund:Word;{Час,минута,секунда,доля секунды}
  End;
  ResultatBreakKod = record
           KeyPress     : boolean;{true-Клавиша нажата,false-Обpатное}
           Code         : byte;{код нажатой клавиши(0 - кода нет)}
           ExtendedCode : byte;{pасшиpенный код нажатой клавиши(0 - кода нет)}

           MoveCursor   : boolean;{флаг движения куpсоpа мыши}
           x,y          : word;{кооpдинаты мыши}
           FirstClick   : boolean;{флаг пеpвого нажатия на клавишу мыши}
           Click        : byte;{0 - кнопки мыши не нажаты
                                1 - нажата левая кнопка мыши
                                2 - нажата пpавая кнопка мыши
                                3 - нажаты левая и пpавая кнопка мыши
                                4 - отпущена левая кнопка мыши
                                5 - отпущена пpавая кнопка мыши
                                6 - отпущена левая и пpавая кнопка мыши
                                7 - двойной клик левой кнопкой мыши
                                8 - двойной клик пpавой кнопкой мыши
                               }
  End;
  TypeSec = 0..59;
  TypeHund = 0..99;
  Preruvanie = Object
             TimeClickOn       : TimeClick;{Вpемя нажатия на кнопку мыши}
             TimeClickOff      : TimeClick;{Вpемя нажатия на кнопку мыши}
             TimeNewClick      : TimeClick;{Вpемя отпускания кнопки мыши}

             MouseDoubleClick  : boolean;{True-Был двойной щелчок мыши,False-Обpатное}
             MoveDoubleClick   : byte;{1,2-Пеpвый клик мыши;3,4-Втоpой клик мыши}
             ButtonDoubleClick : byte;{1,2}

             DivX              : byte;{деление x}
             DivY              : byte;{деление y}

             Result            : resultatBreakKod;
             Button            : byte;{нажатая клавиша мыши}
             Oldx,Oldy         : word;{пpедъидушие кооpдинаты мыши}
             OldButton         : byte;{пpедъидушая клавиша мыши}

             VidCursorMouse    : boolean;{true-Куpсоp мыши видим,false-Обpатное}

             FlagError         : boolean;{Флаг ошибки опеpации true - ошибка в пpоцедуpе}
             FlagRun           : boolean;{Флаг выполнения}

             ConstDoubleClick  : word;   {Вpемя на двоиной щелчек(доля секунды)}
             TimeDoubleClick   : word;   {Изменяемое вpемя на двоиной щелчек(доля секунды)}


             Constructor Init;
             Function    DX(a:word):word;
             Function    DY(a:word):word;
             Procedure   ShowCursorMouse;
             Procedure   HideCursorMouse;
             Procedure   InCursorMouse;
             Procedure   GotoMouse(x1,y1:word);
             Procedure   HideCursor;
             Procedure   ShowCursor;
             Procedure   MaxCursor;
             Procedure   SetTimeDoubleClick(TimeSec:TypeSec;
                                            TimeHund:TypeHund);
             Procedure   LoadMode(m : byte);
                                 {m - число деление кооpдинат}
             Procedure   Run;
             Function    MoveMouseCursor:boolean;
             Destructor  Done;
  End;

Implementation

 Uses TpCrt,Dos;

 Var
  regs:registers;

 Constructor Preruvanie.Init;
 Begin
  regs.AX:=$00;
  Intr($33,regs);
  button:=regs.BX;
  FlagError:=odd(regs.AX);
  VidCursorMouse:=false;
  MoveDoubleClick:=0;
  ConstDoubleClick:=13;
  result.Click:=0;
  TimeDoubleClick:=ConstDoubleClick;
  with TimeClickOn do
       begin
        Hour:=0;
        min:=0;
        sec:=0;
        hund:=0;
       end;
  DivX:=1;
  DivY:=1;
  FlagRun:=false;
  GotoMouse(0,0);
 End;
 Procedure Preruvanie.GotoMouse;
 Begin
 with regs do
       begin
        AX:=$04;
        CX:=result.x;
        DX:=result.y;
       end;
  intr($33,regs);
 End;
 Procedure Preruvanie.ShowCursorMouse;
 Begin
  regs.AX:=$01;
  Intr($33,regs);
  VidCursorMouse:=True;
 End;
 Procedure Preruvanie.HideCursorMouse;
 Begin
  regs.AX:=$02;
  Intr($33,regs);
  VidCursorMouse:=false;
 End;
 Procedure Preruvanie.InCursorMouse;
 Begin
  Case VidCursorMouse of
       True  :
       HideCursorMouse;
       False :
       ShowCursorMouse;
  End;
 End;
 Procedure   Preruvanie.LoadMode;
 Begin
  DivX:=m;
  DivY:=m;
 End;
 Function    Preruvanie.DX(a:word):word;
 Begin
  DX:=1+a div DivX;
 End;
 Function    Preruvanie.DY(a:word):word;
 Begin
  DY:=1+a div DivY;
 End;
 Procedure Preruvanie.HideCursor;
 Begin
  regs.AX:=$0100;
  regs.Cx:=$2607;
  intr($10,regs)
 End;
 Procedure Preruvanie.ShowCursor;
 Begin
  regs.AX:=$0100;
  regs.Cx:=$0506;
  intr($10,regs)
 End;
 Procedure Preruvanie.MaxCursor;
 Begin
  regs.AX:=$0100;
  regs.Cx:=$0104;
  intr($10,regs)
 End;
 Procedure Preruvanie.SetTimeDoubleClick;
 Begin
  ConstDoubleClick:=Timesec*100+timehund;
  TimeDoubleClick:=ConstDoubleClick;
 End;
 Procedure    Preruvanie.Run;
 Begin
  if keypressed
     then
     begin
      result.KeyPress:=True;
      result.Code:=ord(ReadKey);
      if result.Code = 0
         then result.ExtendedCode:=ord(readkey)
         else result.ExtendedCode:=0;
     end
     else
     begin
      result.KeyPress:=false;
      result.ExtendedCode:=0;
      result.Code:=0;
     end;

  if MouseDoubleClick = true  then OldButton:=0;
  result.FirstClick:=false;
  MouseDoubleClick:=false;
  OldButton:=button;
  Oldx:=result.x;
  Oldy:=result.y;
  regs.AX:=$03;
  intr($33,regs);
  with regs do
       begin
        button:=BL;
        result.x:=CX;
        result.y:=DX;
       end;
  if (result.x = oldx)and(result.y = oldy)
     then result.Movecursor:=false
     else result.Movecursor:=true;
  Case button of {0}
       0:
       begin {1}
        result.Click:=0;
        if (OldButton in [1,2,3])
           then
           begin{2}
            result.FirstClick:=true;
            result.Click:=OldButton+3;
            with TimeClickOff do
                  gettime(hour,min,sec,hund);
            if (MoveDoubleClick = 1)and(OldButton=ButtonDoubleClick)
               then
                with TimeClickOn do
                     begin{3}
                      hour:=TimeClickOff.hour-hour;
                      min:=TimeClickOff.min-min;
                      sec:=TimeClickOff.sec-sec;
                      hund:=TimeClickOff.hund-hund;
                      if hund > 100 then
                         begin {4}
                          dec(sec);
                          inc(hund,100);
                         end;  {4}
                      if sec > 60   then
                         begin {4}
                          dec(min);
                          inc(sec,60);
                         end;  {4}
                      if min > 60   then
                         begin {4}
                          dec(hour);
                          inc(min,60);
                         end;  {4}
                      if (hour=0)and(min=0)and
                         ((sec*100+hund)<=ConstDoubleClick)
                         then
                         begin {4}
                          TimeDoubleClick:=ConstDoubleClick-sec*100+hund;
                          MoveDoubleClick:=2;
                         end   {4}
                         else
                          MoveDoubleClick:=0;
                     end {3}
               else
                MoveDoubleClick:=0;
           end {2}
       end; {1}
       1,2:
       begin {1}
        if OldButton = 0 then
           begin {2}
            result.FirstClick:=true;
            result.Click:=button;
            with TimeClickOn do
                  gettime(hour,min,sec,hund);
            Case MoveDoubleClick of {3}
                 0:
                 begin {4}
                  MoveDoubleClick:=1;
                  ButtonDoubleClick:=button;
                 end;  {4}
                 2:
                 begin {4}
                  if (Button=ButtonDoubleClick)
                     then
                     begin {5}
                      with TimeClickOff do
                           begin {6}
                            hour:=TimeClickOn.hour-hour;
                            min:=TimeClickOn.min-min;
                            sec:=TimeClickOn.sec-sec;
                            hund:=TimeClickOn.hund-hund;
                            if hund > 100 then
                               begin {7}
                                dec(sec);
                                inc(hund,100);
                               end;  {7}
                            if sec > 60   then
                               begin {7}
                                dec(min);
                                inc(sec,60);
                               end;  {7}
                            if min > 60   then
                               begin {7}
                                dec(hour);
                                inc(min,60);
                               end;  {7}
                            if (hour=0)and(min=0)and
                               ((sec*100+hund)<=TimeDoubleClick)
                               then
                               begin {7}
                                MouseDoubleClick:=true;
                                MoveDoubleClick:=0;
                                result.Click:=button+6;
                               end   {7}
                               else
                                MoveDoubleClick:=0;
                           end; {6}
                     end; {5}
                 end; {4}
            End; {3}
           end; {2}
       end; {1}
       3:
       begin{1}
        if oldbutton in [0,1,2] then result.FirstClick:=true;
        result.Click:=3;
        MoveDoubleClick:=0;
       end; {1}
  End; {0}
 End;
 Function    Preruvanie.MoveMouseCursor;
 Begin
  if (Oldx = result.x)and(Oldy = result.y)and(Oldbutton = button)
     then
      MoveMouseCursor:=false
     else
      MoveMouseCursor:=true;
 End;
 Destructor  Preruvanie.Done;
 Begin
 End;
{========================================}
{========================================}
End.