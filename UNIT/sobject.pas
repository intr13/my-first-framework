Unit SObject;
Interface
 Uses BreakKod,Graph,OpenGrap;
 Type
  ResultatObject = record
                 Scan         : preruvanie;{��ꥪ� ���p������騩 ������ ������}

                 Focus        : Word;{H���p ��⨢���� �������}
                 PredFocus    : Word;{H���p ��⨢���� �������}

                 ContinueRun  : boolean;{���� ����p����}
                 NewFocus     : boolean;{���� ��������� ��p������� - Focus}
                 exitsss      : boolean;{���� ��室� �� �p�楤�p� Run}
                 FonCl,FontCl : byte;

                 resultObject : integer;{p������ p�����}
  End;
  TypeHotKey = Set of byte;
  TsObject = Object
           FonCl     : byte;{梥� 䮭�}
           FontCl    : byte;{梥� �p���}

           Activ     : byte;{䫠� ��⨢���� ��ꥪ� 0 - �� ��⨢��}
           Visible   : boolean;{���� ����㯭��� ��ꥪ� ��� �������樨}

           CorX,CorY : word;{��p孨� ���� 㣮� ��ꥪ�}

           Nomer     : word;{H���p ��ꥪ�}
           OutPutVid : byte;

           Constructor Init;

           Procedure   SetCorXY(X,Y:word);

           Procedure   OutPut(Var res:ResultatObject);virtual;
           Procedure   GetMouse(var res:ResultatObject);virtual;
           Procedure   Run(var res:ResultatObject);virtual;

           Destructor  Done;
  End;
  TsForm = Object
         MaxX,MaxY    : word;      {���ᨬ��쭠� x � y ���p�����}
         Result       : ResultatObject;

         Constructor Init;

         Procedure   OutPutForm;virtual;
         Procedure   OutPutObject;virtual;
         Procedure   OutPutOneObject(var o:TsObject);virtual;

         Procedure   Run;virtual;
         Procedure   RunObject;virtual;
         Procedure   RunOneObject(Var o:TsObject);virtual;
         Destructor  Done;
   End;
  TsBar = Object(TsObject)
           {pole}
           longx,longy     : word;
           PredZoneMouse   : boolean;   {true - ��p�p �� � ����}
           ZoneMouse       : boolean;   {true - ��p�p �� � ����}
           TabNext,TabPred : word;
           {metod}
           Constructor Init;
           Procedure   SetOptions(N,NTabNext,NTabPred:word);
           Procedure   SetLongXY(X,Y:word);virtual;
           Procedure   GetMouse(Var res:ResultatObject);virtual;
           Procedure   Run(Var res:ResultatObject);virtual;
  End;
Implementation
{==============================================}
{==============================================}
 Constructor TsObject.Init;
 Begin
  CorX:=0;
  CorY:=0;
  Visible:=true;
  Activ:=0;
  Nomer:=0;
  FonCl:=7;
  FontCl:=0;
 End;
 Procedure   TsObject.SetCorXY;
 Begin
  CorX:=X;
  CorY:=Y;
 End;
 Procedure   TsObject.OutPut;
 Begin
 End;
 Procedure   TsObject.GetMouse;
 Begin
 End;
 Procedure   TsObject.Run;
 Begin
 End;
 Destructor  TsObject.Done;
 Begin
 End;
{==============================================}
{==============================================}
 Constructor TsForm.Init;
 Begin
  result.scan.init;
  result.FonCl:=7;
  result.FontCl:=0;
  MaxX:=GetMaxX;
  MaxY:=GetMaxY;
  result.resultobject:=-1;
 End;
 Procedure   TsForm.OutPutForm;
 Begin
  result.Scan.hidecursormouse;
  cleardevice;
  FormBar(0,0,maxx,maxy,16,result.foncl,1,false);
  OutPutObject;
  result.Scan.showcursormouse;
 End;
 Procedure   TsForm.OutPutObject;
 Begin
 End;
 Procedure   TsForm.OutPutOneObject;
 Begin
  o.OutPut(result);
  o.OutPutVid:=0;
 End;
 Procedure  TsForm.Run;
 Begin
  with result do
  begin
   exitsss:=false;
   OutPutForm;
   Scan.showcursormouse;
   NewFocus:=true;
   repeat
    predfocus:=focus;
    Scan.run;
    repeat
     ContinueRun:=false;
     RunObject;
    until not(ContinueRun);
    OutPutObject;
    NewFocus:=false;
   until exitsss;
  end;
 End;
 Procedure  TsForm.RunObject;
 Begin
  with result.scan.result do
   if (keypress)and(extendedcode in [45,107])
      then result.exitsss:=true;
 End;
 Procedure  TsForm.RunOneObject;
 Begin
  result.resultobject:=-1;
  if (o.visible)and not(result.newfocus) then
     begin
      o.GetMouse(result);
      o.run(result);
     end
 End;
 Destructor  TsForm.Done;
 Begin
  result.scan.done;
 End;
{==============================================}
{==============================================}
 Constructor TsBar.Init;
 Begin
  inherited Init;
  TabNext:=0;
  TabPred:=0;
  LongX:=0;
  LongY:=0;
 End;
 Procedure   TsBar.SetLongXY;
 Begin
  LongX:=X;
  LongY:=Y;
 End;
 Procedure   TsBar.GetMouse;
 Begin
  PredZoneMouse:=ZoneMouse;
  with res.scan.result do
  if (x>=Corx)and(x<=longx)and(y>=Cory)and(y<=longy)
     then ZoneMouse:=true
     else ZoneMouse:=false;
 End;
 Procedure   TsBar.SetOptions;
 Begin
  Nomer:=N;
  TabNext:=NTabNext;
  TabPred:=NTabPred;
 End;
 Procedure   TsBar.Run;
 Begin
  with res.scan.result do
       if (click = 0)and(nomer = res.focus)and(keypress) then
          begin
           if (extendedcode = 15) then
              begin
               extendedcode:=0;
               res.NewFocus:=true;
               res.predfocus:=res.focus;
               res.focus:=tabpred;
              end;{shift tab}
           if (code = 9) then
              begin
               code:=0;
               res.NewFocus:=true;
               res.predfocus:=res.focus;
               res.focus:=tabnext;
              end;{tab}
          end;
 End;
{==============================================}
{==============================================}
End.