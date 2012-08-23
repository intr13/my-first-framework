Unit SoButton;

Interface
 Uses SObject,Icon,OpenGrap,Graph,TpCrt;
 Type
  TsMoveBar = Object(TsBar)
           {pole}
           MoveForvard : word;
           MoveBack    : word;
           MoveLeft    : word;
           MoveRigt    : word;
           {metod}
           Constructor Init;
           Procedure   SetMoveObject(f,b,l,r:word);
           Procedure   Run(Var res:ResultatObject);virtual;
  End;
  TsButton = Object(TsMoveBar)
           {pole}
           Textx,Texty     : word;
           str             : string;
           DelaySpase      : word;
           HotCode         : TypeHotKey;
           HotExtendedCode : TypeHotKey;

           PressButton     : boolean;
           ShowAct         : boolean;{флаг отобpажения активности элемента}
           Profil          : byte;{0 - кнопка не нажата,1 - кнопка нажата}
           MoveCr          : boolean;
           UstanovkaActiv  : boolean;

           {metod}

           Constructor Init;
           {отобpажение элемента}
           Procedure   OutPut(Var res:ResultatObject);virtual;
           Procedure   NoPress;virtual;
           Procedure   Press;virtual;
           Procedure   ShowActiv;virtual;
           Procedure   HideActiv;virtual;

           Procedure   SetTextXY(X,Y:word);virtual;
           Procedure   SetDelaySpase(d:word);virtual;
           Procedure   SetString(s:string);virtual;

           Procedure   Run(Var res:ResultatObject);virtual;

           Destructor  Done;
  End;
  IconFunction = procedure(x,y:word;font:byte);
  TsImaginButton = Object(TsButton)
           IconX,IconY : word;
           Icons       : MasIcon8;
           NewIcon     : boolean;

           Constructor Init;
           Procedure   IconXY(X,Y:word;i:MasIcon8);virtual;
           Procedure   InputIcon;virtual;
           Procedure   NoPress;virtual;
           Procedure   Press;virtual;
  End;
  TsNotActivButton = Object(TsImaginButton)
           Procedure   ShowActiv;virtual;
           Procedure   HideActiv;virtual;
  End;
  TsShadowButton = Object(TsImaginButton)
           Constructor Init;
           Procedure   OutPut(Var res:ResultatObject);virtual;
           Procedure   NoPress;virtual;
           Procedure   shadowpress;virtual;
           Procedure   Run(Var res:ResultatObject);virtual;
  End;
  TsPressButton = Object(TsNotActivButton)
           Procedure   Run(Var res:ResultatObject);virtual;
  End;

Implementation
{==============================================}
{==============================================}
 Constructor TsMoveBar.Init;
 Begin
  inherited init;
  MoveForvard:=0;
  MoveBack:=0;
  MoveLeft:=0;
  MoveRigt:=0;
 End;
 Procedure   TsMoveBar.SetMoveObject;
 Begin
  MoveForvard:=f;
  MoveBack:=b;
  MoveLeft:=l;
  MoveRigt:=r;
 End;
 Procedure   TsMoveBar.Run;
 Begin
  inherited run(res);
  with res.scan.result do
       if (click = 0)and(nomer = res.focus)and(keypress) then
           Case extendedcode of
                72:{verh}
                if Moveforvard <> 0 then
                begin
                 res.NewFocus:=true;
                 res.predfocus:=res.focus;
                 res.focus:=Moveforvard;
                 extendedcode:=0;
                end;
                75:{left}
                if Moveleft <> 0 then
                begin
                 res.NewFocus:=true;
                 res.predfocus:=res.focus;
                 res.focus:=Moveleft;
                 extendedcode:=0;
                end;
                77:{rigt}
                if Moverigt <> 0 then
                begin
                 res.NewFocus:=true;
                 res.predfocus:=res.focus;
                 res.focus:=Moverigt;
                 extendedcode:=0;
                end;
                80:{nizz}
                if Moveback <> 0 then
                begin
                 res.NewFocus:=true;
                 res.predfocus:=res.focus;
                 res.focus:=Moveback;
                 extendedcode:=0;
                end;
           End
 End;
{==============================================}
{==============================================}
 Constructor TsButton.Init;
 Begin
  inherited init;
  delayspase:=13333;
  hotcode:=[];
  hotextendedcode:=[];
  OutPutVid:=1;
  ShowAct:=false;
  profil:=0;
  movecr:=false;
  UstanovkaActiv:=true;
 End;
 Procedure   TsButton.OutPut;
 Begin
  if OutPutVid <> 0 then
     begin
      foncl:=res.foncl;
      fontcl:=res.fontcl;
      res.scan.hidecursormouse;
      Case profil of
           0:NoPress;
           1:Press;
      End;
      if nomer = res.focus then ShowActiv;
      res.scan.showcursormouse;
     end;
  if res.newfocus then
     begin
      if nomer = res.predfocus then
         begin
          res.scan.hidecursormouse;
          hideactiv;
          res.scan.showcursormouse;
         end;
      if nomer = res.focus then
         begin
          res.scan.hidecursormouse;
          showactiv;
          res.scan.showcursormouse;
         end;
     end;
 End;
 Procedure   TsButton.NoPress;
 Begin
  barshadow(corx,cory,longx,longy,false,foncl);
  setcolor(fontcl);
  outtextxy(Textx,Texty,str);
 End;
 Procedure   TsButton.Press;
 Begin
  barshadow(corx,cory,longx,longy,true,foncl);
  setcolor(fontcl);
  outtextxy(Textx+1,Texty+1,str);
 End;
 Procedure   TsButton.ShowActiv;
 Begin
  if profil = 1
     then barprerline(corx+4,cory+4,longx-3,longy-3,fontcl)
     else barprerline(corx+3,cory+3,longx-4,longy-4,fontcl)
 End;
 Procedure   TsButton.HideActiv;
 Begin
  if profil = 1
     then barprerline(corx+4,cory+4,longx-3,longy-3,foncl)
     else barprerline(corx+3,cory+3,longx-4,longy-4,foncl);
 End;
 Procedure   TsButton.SetTextXY;
 Begin
  TextX:=X;
  TextY:=Y;
 End;
 Procedure   TsButton.SetDelaySpase;
 Begin
  delayspase:=d;
 End;
 Procedure   TsButton.SetString;
 Begin
  str:=s;
 End;
 Procedure   TsButton.run;
 Begin
  inherited run(res);
  with res.scan.result do
  begin
   if (UstanovkaActiv)and(click = 0)and(nomer = res.focus)and(keypress)and(code = 32) then
      begin
       res.scan.hidecursormouse;
       Press;
       ShowActiv;
       res.scan.showcursormouse;
       delay(DelaySpase);
       profil:=0;
       OutPutVid:=1;
       code:=0;
       res.resultObject:=0;
       exit;
      end;
   if (click=0)and(keypress)and((code in HotCode)or(extendedcode in hotextendedcode)) then
      begin
       res.scan.hidecursormouse;
       Press;
       ShowActiv;
       res.scan.showcursormouse;
       delay(DelaySpase);
       profil:=0;
       OutPutVid:=1;
       code:=0;
       extendedcode:=0;
       if (res.focus <> nomer)and(UstanovkaActiv) then
          begin
           res.focus:=nomer;
           res.Newfocus:=true;
          end;
       res.resultObject:=0;
       exit;
      end;
   if ZoneMouse
      then
       Case click of
            1:
            begin
             if (profil = 0)and(movecr) then
                begin
                 res.resultObject:=1;
                 OutPutVid:=1;
                 profil:=1;
                 movecr:=false;
                 exit;
                end;
             if (profil = 0)and(firstclick) then
                 begin
                  res.resultObject:=1;
                  OutPutVid:=1;
                  profil:=1;
                  if (res.focus <> nomer)and(UstanovkaActiv) then
                     begin
                      res.focus:=nomer;
                      res.Newfocus:=true;
                     end;
                  exit;
                 end;
            end;
            4:
            if (profil = 1) then
               begin
                res.resultObject:=0;
                OutPutVid:=2;
                profil:=0;
                exit;
               end;
       End
      else
       if (profil = 1)
          then
          begin
           if (click = 1)and(movecr = false)
              then
              begin
               OutPutVid:=1;
               movecr:=true;
               profil:=0;
               res.resultObject:=2;
               exit;
              end ;
          end
          else
          begin
           if (click <> 1)and(movecr = true)
              then
              begin
               OutPutVid:=1;
               movecr:=false;
               profil:=0;
               exit;
              end;
          end;
  end;
 End;
 Destructor  TsButton.Done;
 Begin
  inherited done;
 End;
{==============================================}
{==============================================}
 Constructor TsImaginButton.Init;
 Begin
  inherited init;
  NewIcon:=false;
 End;
 Procedure   TsImaginButton.IconXY;
 Begin
  IconX:=x;
  Icony:=y;
  Icons:=i;
  NewIcon:=true;
 End;
 Procedure   TsImaginButton.InputIcon;
 Begin
  if (outputvid <> 0)and NewIcon then
     Case profil of
         0:OutPutIcon8(IconX,IconY,Icons);
         1:OutPutIcon8(IconX+1,IconY+1,Icons);
     End;
 End;
 Procedure   TsImaginButton.NoPress;
 Begin
  inherited NoPress;
  InputIcon;
 End;
 Procedure   TsImaginButton.Press;
 Begin
  inherited Press;
  InputIcon;
 End;
{==============================================}
{==============================================}
 Procedure   TsNotActivButton.ShowActiv;
 Begin
 End;
 Procedure   TsNotActivButton.HideActiv;
 Begin
 End;
{==============================================}
{==============================================}
 Procedure   TsPressButton.Run;
 Begin
  with res.scan.result do
  begin
   if ((click=0)and(keypress)and((code in HotCode)or(extendedcode in hotextendedcode)))
      or((click=1)and(firstclick)and(Zonemouse))
      then
      begin
       Case profil of
            0:profil:=1;
            1:profil:=0;
       End;
       res.resultObject:=profil;
       OutPutVid:=1;
       code:=0;
       extendedcode:=0;
       exit;
      end;
  end;
 End;
{==============================================}
{==============================================}
 Constructor TsShadowbutton.Init;
 Begin
  inherited init;
  UstanovkaActiv:=false;
 End;
 Procedure   TsShadowbutton.OutPut;
 Begin
  inherited Output(res);
  if (OutPutVid <> 0)and(profil = 2) then
     begin
      res.scan.hidecursormouse;
      shadowpress;
      res.scan.showcursormouse;
     end;
 End;
 Procedure   TsShadowbutton.NoPress;
 Begin
  setfillstyle(1,foncl);
  bar(corx,cory,longx,longy);
  setcolor(fontcl);
  outtextxy(Textx+1,Texty+1,str);
  InputIcon;
 End;
 Procedure   TsShadowbutton.shadowpress;
 Begin
  inherited NoPress;
  if (outputvid <> 0)and(NewIcon)and(profil = 2)
     then OutPutIcon8(IconX-1,IconY-1,Icons);
 End;
 Procedure   TsShadowbutton.Run;
 Begin
  with res.scan.result do
       if (click = 0)and(keypress)and
          ((code in hotcode)or(extendedcode in hotextendedcode)) then
          begin
           code:=0;
           extendedcode:=0;
           res.resultobject:=0;
           exit;
          end;
  if (not movecr)and(not PredZoneMouse)and(ZoneMouse)and(res.scan.result.click = 0) then
     begin
      OutPutVid:=1;
      profil:=2;
     end;
  with res.scan.result do
   if ZoneMouse
      then
       Case click of
            1:
            begin
             if (profil in [0,2])and(movecr) then
                begin
                 res.resultObject:=1;
                 OutPutVid:=1;
                 profil:=1;
                 movecr:=false;
                 exit;
                end;
             if (profil in [0,2])and(firstclick) then
                 begin
                  res.resultObject:=1;
                  OutPutVid:=1;
                  profil:=1;
                  exit;
                 end;
            end;
            4:
            if (profil = 1) then
               begin
                res.resultObject:=0;
                OutPutVid:=1;
                profil:=2;
                movecr:=false;
                exit;
               end;
       End
      else
       if (profil = 1)
          then
          begin
           if (click = 1)and(movecr = false)
              then
              begin
               OutPutVid:=1;
               movecr:=true;
               profil:=0;
               res.resultObject:=2;
               exit;
              end;
          end
          else
          begin
           if (click <> 1)and(movecr = true)
              then
              begin
               OutPutVid:=1;
               movecr:=false;
               profil:=0;
               exit;
              end;
          end;
  if (not movecr)and(PredZoneMouse)and(not ZoneMouse) then
     begin
      OutPutVid:=1;
      profil:=0;
     end;
 End;
{==============================================}
{==============================================}
End.