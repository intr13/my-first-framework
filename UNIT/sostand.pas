Unit SoStand;
Interface
 Uses BreakKod,SObject,SoButton,OpenGrap,icon;
 Type
  TsButtonExit = Object(TsNotActivButton)
               ButtonYes  : TsButton;
               ButtonNo   : TsButton;
               SaveFocus  : word;
               ExtMenu    : ScrenGraph;

               Constructor Init;

               Procedure   Run(var res:ResultatObject);virtual;
               Procedure   RunButtonExit(var res:ResultatObject);virtual;

               Destructor  Done;
 End;
Implementation
 Uses Graph,TpCrt;

 Constructor TsButtonExit.Init;
 Begin
  inherited init;

  ExtMenu.init;

  UstanovkaActiv:=false;
  showact:=false;
  IconXY(625,6,Icon8_2);
  hotextendedcode:=[107];
  setcorxy(623,4);
  setlongxy(635,16);

  ButtonYes.init;
  buttonYes.SetOptions(1,2,2);
  buttonYes.SetMoveObject(2,2,2,2);
  buttonYes.visible:=false;
  buttonYes.hotcode:=[13,89,121,132,164];
  buttonYes.setcorxy(230,230);
  buttonYes.setlongxy(310,250);
  buttonYes.settextxy(262,235);
  buttonYes.setstring('Да');

  ButtonNo.init;
  buttonNo.SetOptions(2,1,1);
  buttonNo.SetMoveObject(1,1,1,1);
  buttonNo.visible:=false;
  buttonNo.hotcode:=[27,78,110,141,173];
  buttonNo.setcorxy(320,230);
  buttonNo.setlongxy(400,250);
  buttonNo.settextxy(348,235);
  buttonNo.setstring('Hет');
 End;
 Procedure   TsButtonExit.Run;
 Begin
  inherited Run(res);
  if (res.focus <> nomer)and(res.resultobject = -1) then SaveFocus:=res.predfocus;
  if res.resultobject = 0 then RunButtonExit(res);
 End;
 Procedure   TsButtonExit.RunButtonExit;
 Begin
  OutPut(res);
  res.exitsss:=false;
  res.scan.hidecursormouse;
  extmenu.copy(220,170,410,260);
  setfillstyle(1,1);
  FormBar(220,170,410,260,16,foncl,1,true);
  setcolor(15);
  outtextxy(230,176,'Подтвеpждение');
  setcolor(fontcl);
  outtextxy(230,200,'Действительно выйти');
  outtextxy(230,215,'из пpогpаммы?');
  res.scan.showcursormouse;
  res.focus:=buttonNo.nomer;
  res.predfocus:=0;
  buttonYes.OutPutVid:=2;
  buttonYes.output(res);
  buttonNo.OutPutVid:=2;
  buttonNo.output(res);
  repeat
   res.predfocus:=res.focus;
   res.Newfocus:=false;
   res.Scan.run;
   with res.scan.result do
        if (keypress)and(extendedcode = 107) then
            begin
             res.exitsss:=true;
             res.Focus:=buttonYes.nomer;
             res.predfocus:=res.focus;
             break;
            end;
   res.resultobject:=-1;
   buttonYes.GetMouse(res);
   buttonYes.run(res);
   if res.resultobject = 0 then res.exitsss:=true;
   res.resultobject:=-1;
   buttonNo.GetMouse(res);
   buttonNo.run(res);
   if res.resultobject = 0 then res.exitsss:=true;
   buttonYes.output(res);
   buttonNo.output(res);
   buttonYes.OutPutVid:=0;
   buttonNo.OutPutVid:=0;
  until res.exitsss;
  if res.focus = buttonNo.Nomer then res.exitsss:=false;
  res.scan.hidecursormouse;
  extmenu.paste(220,170);
  res.scan.showcursormouse;
  res.focus:=SaveFocus;
  res.predfocus:=res.focus;
 End;
 Destructor  TsButtonExit.Done;
 Begin
  ButtonYes.done;
  ButtonNo.done;
  ExtMenu.done;
  inherited init;
 End;
{==============================================}
{==============================================}
End.