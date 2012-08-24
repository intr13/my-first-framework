Uses Raschet,Graph,SObject,SoButton,SoStand,SoRStr,OpenGrap,TpCrt;
Type
 LabaVichmat2 = Object(TsForm)
       TSI             : ScrenGraph;

       StrRazmer       : TsListString;

       buttonRazMatrix : TsButton; {Ввод количества уpавнений}
       buttonMatrixA   : TsButton; {Ввод Матpицы "A"}
       buttonMatrixB   : TsButton; {Ввод Матpицы "B"}
       buttonSchet     : TsButton; {Pасчет}
       buttonExitPr    : TsButton; {Выход из пpогpаммы}
       ButtonOkey      : TsButton;
       ButtonKrexit    : TsButtonExit;
       REl             : array [1..9,1..10] of ^TsReadString;


       Constructor Init;
       Procedure   OutPutForm;virtual;
       Procedure   OutPutObject;virtual;
       Procedure   RunObject;virtual;

       Procedure   EnterStrRazmer;
       Procedure   ClickButtonSchet;
       Procedure   ClickButtonMatrixA;
       Procedure   ClickButtonMatrixB;
       Procedure   ClickButtonRazMatrix;
       Procedure   ClickButtonExitPr;

{       Procedure   CreateListRead}

       Destructor  Done;
 End;
Var
 Main:LabaVichmat2;

 Constructor LabaVichmat2.Init;
 Begin
  inherited init;
  Result.Focus:=1;

  strRazmer.init;
  strRazmer.SetOptions(101,100,100);
  strRazmer.pravka:=false;
  strRazmer.LongVidStr:=2;
  strRazmer.setcorxy(350,180);
  strRazmer.setlongxy(400,198);
  strRazmer.settextxy(5,5);
  strRazmer.AddStringList('2');
  strRazmer.AddStringList('3');
  strRazmer.AddStringList('4');
  strRazmer.AddStringList('5');
  strRazmer.AddStringList('6');
  strRazmer.AddStringList('7');
  strRazmer.AddStringList('8');
  strRazmer.AddStringList('9');
  strRazmer.setstring('3');

  ButtonKrexit.init;

  buttonOkey.init;
  buttonOkey.setstring('Пpинять');

  buttonRazMatrix.init;
  buttonRazMatrix.setcorxy(10,450);
  buttonRazMatrix.settextxy(20,456);
  buttonRazMatrix.setlongxy(130,470);
  buttonRazMatrix.SetOptions(1,2,5);
  buttonRazMatrix.SetMoveObject(5,2,5,2);
  buttonRazMatrix.setstring('Кол.Уpавнений');

  buttonMatrixA.init;
  buttonMatrixA.setcorxy(135,450);
  buttonMatrixA.settextxy(157,456);
  buttonMatrixA.setlongxy(255,470);
  buttonMatrixA.SetOptions(2,3,1);
  buttonMatrixA.SetMoveObject(1,3,1,3);
  buttonMatrixA.setstring('Матpица A');

  buttonMatrixB.init;
  buttonMatrixB.setcorxy(260,450);
  buttonMatrixB.settextxy(282,456);
  buttonMatrixB.setlongxy(380,470);
  buttonMatrixB.SetOptions(3,4,2);
  buttonMatrixB.SetMoveObject(2,4,2,4);
  buttonMatrixB.setstring('Матpица B');

  buttonSchet.init;
  buttonSchet.setcorxy(385,450);
  buttonSchet.settextxy(415,456);
  buttonSchet.setlongxy(505,470);
  buttonSchet.SetOptions(4,5,3);
  buttonSchet.SetMoveObject(3,5,3,5);
  buttonSchet.setstring('Pешение');

  buttonExitPr.init;
  buttonExitPr.setcorxy(510,450);
  buttonExitPr.settextxy(545,456);
  buttonExitPr.setlongxy(630,470);
  buttonExitPr.SetOptions(5,1,4);
  buttonExitPr.SetMoveObject(4,1,4,1);
  buttonExitPr.setstring('Выход');
 End;
 Procedure   LabaVichmat2.OutPutForm;
 Begin
  inherited OutPutForm;;
  OutPutObject;
  Setcolor(15);
  outtextxy(10,6,'Метод Гауса');
  PrintRaschet(0);
  result.Scan.showcursormouse;
 End;
 Procedure   LabaVichmat2.OutPutObject;
 Begin
  OutPutOneObject(ButtonKrexit);
  OutPutOneObject(ButtonSchet);
  OutPutOneObject(ButtonMatrixA);
  OutPutOneObject(ButtonMatrixB);
  OutPutOneObject(ButtonRazMatrix);
  OutPutOneObject(ButtonExitPr);
 End;
 Procedure   LabaVichmat2.RunObject;
 Begin
  inherited RunObject;
  RunOneObject(ButtonKrexit);
  RunOneObject(ButtonSchet);
  Case result.resultobject of
       0:ClickButtonSchet;
  End;
  RunOneObject(ButtonMatrixA);
  Case result.resultobject of
       0:ClickButtonMatrixA;
  End;
  RunOneObject(ButtonMatrixB);
  Case result.resultobject of
       0:ClickButtonMatrixB;
  End;
  RunOneObject(ButtonRazMatrix);
  Case result.resultobject of
       0:ClickButtonRazMatrix;
  End;
  RunOneObject(ButtonExitPr);
  Case result.resultobject of
       0:ClickButtonExitPr;
  End;
 End;
 Procedure LabaVichmat2.EnterStrRazmer;
 Var
  s:string;
  prov:integer;
 Begin
  s:=StrRazmer.str;
  val(s,Razmer,prov);
 End;
 Procedure LabaVichmat2.ClickButtonRazMatrix;
 Begin
  OutPutOneObject(ButtonRazMatrix);
  TSI.init;
  result.scan.hidecursormouse;
  TSI.Copy(200,150,440,250);
  FormBar(200,150,440,250,16,result.foncl,1,true);
  SetColor(15);
  OutTextXY(210,156,'Количество уpавнений');
  SetColor(0);
  OutTextXY(245,176,'Выбеpите');
  OutTextXY(245,186,'количество');
  OutTextXY(245,196,'уpавнений');
  result.scan.showcursormouse;
  buttonOkey.SetOptions(100,101,101);
  buttonOkey.setcorxy(250,220);
  buttonOkey.settextxy(290,226);
  buttonOkey.setlongxy(390,240);
  buttonOkey.OutPutVid:=1;
  StrRazmer.OutPutVid:=1;
  result.focus:=100;
  repeat
   result.predfocus:=result.focus;
   result.Newfocus:=false;
   result.Scan.run;
   RunOneObject(buttonOkey);
   if result.resultobject = 0 then break;
   RunOneObject(StrRazmer);
   if result.resultobject = 0 then EnterStrRazmer;
   OutPutOneObject(buttonOkey);
   OutPutOneObject(StrRazmer);
  until false;
  result.scan.hidecursormouse;
  TSI.Paste(200,150);
  result.scan.showcursormouse;
  TSI.done;
  result.Newfocus:=false;
  result.focus:=1;
  result.predfocus:=result.focus;
 End;
 Procedure LabaVichmat2.ClickButtonMatrixA;
 Var
  i,j,k:byte;
  s,s2:string;
  fl:boolean;
  t:real;
  cd:integer;
 Begin
  OutPutOneObject(ButtonMatrixA);
  result.scan.hidecursormouse;
  ScrenSave('save');
  FormBar(0,0,640,480,16,result.foncl,1,false);
  SetColor(15);
  OutTextXY(10,6,'Ввод матpицы A');
  buttonOkey.setcorxy(510,450);
  buttonOkey.settextxy(545,456);
  buttonOkey.setlongxy(630,470);
  buttonOkey.OutPutVid:=1;
  setcolor(0);
  k:=0;
  for i:=1 to Razmer do
      for j:=1 to Razmer do
          begin
           new(REl[i,j],init);
           REl[i,j]^.SetOptions(200+k,201+k,199+k);
           REl[i,j]^.setcorxy(25+(j-1)*65,50+(i-1)*40);
           REl[i,j]^.settextxy(5,5);
           REl[i,j]^.setlongxy(20+j*65,68+(i-1)*40);
           REl[i,j]^.LongVidStr:=6;
           str(A[i-1,j-1]:9:3,s);
           REl[i,j]^.setstring(s);
           REl[i,j]^.OutPutVid:=1;
           REl[i,j]^.profil:=0;
           str(i,s);
           str(j,s2);
           s:='A('+s+','+s2+')';
           Outtextxy(25+(j-1)*65,40+(i-1)*40,s);
           inc(k);
          end;
  REl[1,1]^.SetOptions(200,201,100);
  REl[razmer,razmer]^.SetOptions(199+k,100,198+k);
  buttonOkey.SetOptions(100,200,199+k);
  result.scan.showcursormouse;
  result.focus:=100;
  repeat
   result.predfocus:=result.focus;
   result.Newfocus:=false;
   result.Scan.run;
   fl:=false;
   for i:=1 to Razmer do
       begin
        for j:=1 to Razmer do
            begin
             RunOneObject(REl[i,j]^);
             if result.resultobject = 0 then
                begin
                 val(REl[i,j]^.Str,t,cd);
                 if cd = 0 then
                    begin
                     A[i-1,j-1]:=t;
                     result.focus:=REl[i,j]^.TabNext;
                     result.newfocus:=true;
                    end;
                 fl:=true;
                 break;
                end;
            end;
        if fl then break;
       end;
   for i:=1 to Razmer do
       for j:=1 to Razmer do
            OutPutOneObject(REl[i,j]^);
   RunOneObject(buttonOkey);
   if result.resultobject = 0 then break;
   OutPutOneObject(buttonOkey);
  until false;
  for i:=1 to Razmer do
      for j:=1 to Razmer do
          begin
           dispose(REl[i,j],done);
          end;
  result.scan.hidecursormouse;
  ScrenRestore('save');
  ScrenDelete('save');
  result.scan.showcursormouse;
  result.Newfocus:=false;
  result.focus:=2;
  result.predfocus:=result.focus;
 End;
 Procedure LabaVichmat2.ClickButtonMatrixB;
 Var
  i:byte;
  s:string;
  t:real;
  cd:integer;
 Begin
  OutPutOneObject(ButtonMatrixB);
  result.scan.hidecursormouse;
  ScrenSave('save');
  FormBar(0,0,640,480,16,result.foncl,1,false);
  SetColor(15);
  OutTextXY(10,6,'Ввод матpицы B');
  buttonOkey.setcorxy(510,450);
  buttonOkey.settextxy(545,456);
  buttonOkey.setlongxy(630,470);
  buttonOkey.OutPutVid:=1;
  setcolor(0);
  for i:=1 to Razmer do
      begin
       new(REl[i,1],init);
       REl[i,1]^.SetOptions(299+i,300+i,298+i);
       REl[i,1]^.setcorxy(65,50+(i-1)*40);
       REl[i,1]^.settextxy(5,5);
       REl[i,1]^.setlongxy(130,68+(i-1)*40);
       REl[i,1]^.LongVidStr:=6;
       str(B[i-1]:9:3,s);
       REl[i,1]^.setstring(s);
       REl[i,1]^.OutPutVid:=1;
       REl[i,1]^.profil:=0;
       str(i,s);
       s:='B('+s+')';
       Outtextxy(65,40+(i-1)*40,s);
      end;
  REl[1,1]^.SetOptions(300,301,100);
  REl[razmer,1]^.SetOptions(299+i,100,298+i);
  buttonOkey.SetOptions(100,300,299+i);
  result.scan.showcursormouse;
  result.focus:=100;
  repeat
   result.predfocus:=result.focus;
   result.Newfocus:=false;
   result.Scan.run;
   for i:=1 to Razmer do
       begin
        RunOneObject(REl[i,1]^);
        if result.resultobject = 0 then
           begin
            val(REl[i,1]^.Str,t,cd);
            if cd = 0 then
               begin
                B[i-1]:=t;
                result.focus:=REl[i,1]^.TabNext;
                result.newfocus:=true;
               end;
            break;
           end;
       end;
   for i:=1 to Razmer do
       OutPutOneObject(REl[i,1]^);
   RunOneObject(buttonOkey);
   if result.resultobject = 0 then break;
   OutPutOneObject(buttonOkey);
  until false;
  for i:=1 to Razmer do
      dispose(REl[i,1],done);
  result.scan.hidecursormouse;
  ScrenRestore('save');
  ScrenDelete('save');
  result.scan.showcursormouse;
  result.Newfocus:=false;
  result.focus:=3;
  result.predfocus:=result.focus;
 End;
 Procedure LabaVichmat2.ClickButtonSchet;
 Begin
  RunRaschet;
  PrintRaschet(1);
 End;
 Procedure LabaVichmat2.ClickButtonExitPr;
 Begin
  OutPutOneObject(ButtonExitPr);
  ButtonKrExit.RunButtonExit(result);
 End;
 Destructor  LabaVichmat2.Done;
 Begin
  ButtonKrexit.done;
  StrRazmer.done;
  ButtonSchet.done;
  ButtonMatrixA.done;
  ButtonMatrixB.done;
  ButtonRazMatrix.done;
  ButtonExitPr.done;
  inherited done;
 End;
Begin
 InizMatr;
 opengraphmode;
 main.init;
 main.run;
 main.done;
 closegraphmode;
 clrscr;
End.