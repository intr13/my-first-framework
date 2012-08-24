Unit SoRStr;

Interface
 Uses SObject,SoButton,Graph,opengrap,tpcrt,Icon;
 Type
  TsReadString = Object(TsBar)
           {pole}
           textx,texty              : word;

           DostupCode               : TypeHotKey;
           DostupExtendedCode       : TypeHotKey;

           Str,StrTemp              : string;
           VidStr                   : string; {вид стpоки в окне}

           Cr                       : byte;   {позиция куpсоpа}
           CrVid,predcrvid          : byte;   {позиция куpсоpа начала копиpования}
           LongVidStr               : byte;   {pазмеp окна ввода}
           Profil                   : byte;
           VudelenieStr             : boolean;{Выделение стpоки для удаления}
           StrDelete                : boolean;{Удаление стpоки}
           PravkaStr                : boolean;{Hачало измения стpоки}
           Pravka                   : boolean;{pазpешение на изменение стpоки}
           Maxlong                  : byte;   {Максимальное число символов в стpоке}

           {metod}
           Constructor Init;
           Procedure   SetString(s:string);
           Procedure   SetTextXY(X,Y:word);
           Procedure   OutPut(Var res:ResultatObject);virtual;
           Procedure   Run(Var res:ResultatObject);virtual;
  End;
  PtrStringList = ^StringList;
  StringList = record
             Next,Pred : PtrStringList;
             Str       : string;
  End;
  TsListString = Object(TsReadString)
           NachaloList : PtrStringList;
           TimeList    : PtrStringList;
           KolList     : byte;
           ActivList   : byte;
           sv          : ScrenGraph;
           ButtonList  : TsPressButton;
           Napravlenie : boolean;

           Constructor Init;
           Procedure   SetLongXY(X,Y:word);virtual;
           Procedure   AddStringList(s:string);
           Procedure   OutPut(Var res:ResultatObject);virtual;
           Procedure   Run(Var res:ResultatObject);virtual;
           Procedure   RunList(Var res:ResultatObject);virtual;
           Procedure   OutPutList(Var res:ResultatObject);virtual;
           Destructor  Done;
  End;

Implementation
{==============================================}
{==============================================}
 Constructor TsReadString.Init;
 Begin
  inherited init;
  OutPutVid:=1;
  Dostupcode:=[33..126];
  DostupExtendedCode:=[];
  pravkastr:=false;
  VudelenieStr:=false;
  StrDelete:=false;
  Str:='';
  maxlong:=255;
  crVid:=0;
  pravka:=true;
 End;
 Procedure   TsReadString.SetString(s:string);
 Begin
  str:=s;
  strtemp:=s;
  cr:=length(str);
  if cr > longvidstr
     then crvid:=cr-longvidstr
     else crvid:=0;
 End;
 Procedure   TsReadString.SetTextXY(X,Y:word);
 Begin
  Textx:=x;
  Texty:=y;
 End;
 Procedure   TsReadString.OutPut;
 Var
  i,k : integer;
 Begin
  if OutPutVid <> 0 then
     begin
      foncl:=res.foncl;
      fontcl:=res.fontcl;
      res.scan.hidecursormouse;
      Case profil of
           0:
           begin
            barshadow(corx,cory,longx,longy,true,15);
            setcolor(fontcl);
           end;
           1:
           begin
            barshadow(corx,cory,longx,longy,true,15);
            setcolor(15);
            setfillstyle(1,1);
            if length(strtemp) < longvidstr
               then
                bar(corx+Textx-1,cory+Texty-2,corx+Textx+length(strtemp)*9-1,cory+Texty+10)
               else
                bar(corx+Textx-1,cory+Texty-2,corx+Textx+longvidstr*9-1,cory+Texty+10);
            StrDelete:=true;
           end;
      End;
      i:=length(strtemp)-crvid;
      if i > longvidstr then i:=longvidstr;
      vidstr:=copy(strtemp,Crvid+1,i);
      for k:=1 to i do
          outtextxy(corx+Textx+(k-1)*9,cory+Texty,vidstr[k]);
      if (pravkastr)and(pravka)
         then line(corx+Textx-1+(cr-crvid)*9,cory+Texty-2,corx+Textx-1+(cr-crvid)*9,cory+Texty+10);
      res.scan.showcursormouse;
     end;
 End;
 Procedure   TsReadString.Run(Var res:ResultatObject);
 Var
  i,j:byte;
 Begin
  inherited run(res);
  with res.scan.result do
  begin
   if (nomer = res.focus)and not(pravkastr)
      then
      begin
       pravkastr:=true;
       OutPutVid:=1;
       strtemp:=str;
       if strtemp = ''
          then profil:=0
          else profil:=1;
       cr:=length(strtemp);
       if cr > longvidstr
          then crvid:=cr-longvidstr
          else crvid:=0;
      end;
   if (nomer <> res.focus)and(pravkastr)
      then
      begin
       pravkastr:=false;
       OutPutVid:=1;
       profil:=0;
       strtemp:=str;
       cr:=length(strtemp);
       if cr > longvidstr
          then crvid:=cr-longvidstr
          else crvid:=0;
      end;
   if (pravkastr = true)and(keypress) then
      begin
       if strdelete then
           if (code = 8)or(extendedcode = 83)
              or(code in DostupCode)or(extendedcode in DostupextendedCode)
              then
              begin
               if not pravka then exit;
               strtemp:='';
               profil:=0;
               OutPutVid:=1;
               cr:=0;
               crvid:=0;
               strdelete:=false;
               if (code = 83)or(extendedcode = 8) then exit;
              end
              else
              begin
               if not pravka then exit;
               profil:=0;
               OutPutVid:=1;
               strdelete:=false;
              end;
       Case extendedcode of
            75:{left}
            if cr <> 0 then
               begin
                if not pravka then exit;
                OutPutVid:=1;
                profil:=0;
                if cr = crvid
                   then
                    dec(crvid);
                dec(cr);
               end;
            77:{rigt}
            if cr <> length(strtemp) then
               begin
                if not pravka then exit;
                OutPutVid:=1;
                profil:=0;
                if (cr-crvid) = longvidstr
                   then
                    inc(crvid);
                inc(cr);
               end;
            83:{del}
            if cr <> length(strtemp) then
               begin
                if not pravka then exit;
                delete(strtemp,cr+1,1);
                OutPutVid:=1;
                profil:=0;
               end;
            71:{home}
            if cr <> 0 then
               begin
                if not pravka then exit;
                OutPutVid:=1;
                profil:=0;
                CrVid:=0;
                cr:=0;
               end;
            79:{end}
            if cr <> length(strtemp) then
               begin
                if not pravka then exit;
                OutPutVid:=1;
                profil:=0;
                cr:=length(strtemp);
                if length(strtemp)<=longvidstr
                   then crvid:=0
                   else crvid:=length(strtemp)-longvidstr;
               end;
            else
            if (length(strtemp) < maxlong)and(extendedcode in DostupextendedCode) then
               begin
                if not pravka then exit;
                profil:=0;
                OutPutVid:=1;
                insert(char(code),strtemp,Cr+1);
                if (cr-crvid) = longvidstr
                   then
                    inc(crvid);
                inc(cr);
               end;
       End;
       Case code of
            8:{Backspase}
            if cr <> 0 then
               begin
                if not pravka then exit;
                delete(strtemp,cr,1);
                if cr = crvid then dec(crvid);
                OutPutVid:=1;
                profil:=0;
                dec(cr);
               end;
            13:{Enter}
            begin
             res.resultobject:=0;
             str:=strtemp;
            end;
            27:{Esc}
            begin
             if not pravka then exit;
             OutPutVid:=1;
             profil:=1;
             strtemp:=str;
             cr:=length(strtemp);
             if cr > longvidstr
                then crvid:=cr-longvidstr
                else crvid:=0;
            end;
            else
            if (length(strtemp) < maxlong)and(code in DostupCode) then
               begin
                if not pravka then exit;
                OutPutVid:=1;
                profil:=0;
                insert(char(code),strtemp,Cr+1);
                if (cr-crvid) = longvidstr
                   then
                    inc(crvid);
                inc(cr);
               end;
          End;
      end;
  end;
  with res.scan.result do
       if ZoneMouse
          then
          begin
           if (firstclick)and(click = 1) then
              if (pravkastr)
                 then
                 begin
                  if not pravka then exit;
                  j:=length(strtemp)-crvid;
                  if j > longvidstr then j:=longvidstr;
                  for i:=0 to j do
                      if ((corx+Textx-5+i*9)<x)
                         and((corx+Textx+6+i*9)>x)
                         and((cory+Texty-2)<y)
                         and((cory+Texty+10)>y)
                         then
                         begin
                          cr:=crvid+i;
                          OutPutVid:=1;
                          profil:=0;
                         end;
                 end
                 else
                 begin
                  strtemp:=str;
                  if strtemp = ''
                     then profil:=0
                     else profil:=1;
                  OutPutVid:=1;
                  pravkastr:=true;
                  cr:=length(strtemp);
                  if cr > longvidstr
                     then crvid:=cr-longvidstr
                     else crvid:=0;
                  res.Newfocus:=true;
                  if res.focus <> nomer
                     then res.focus:=nomer;
                 end;
          end;
 End;
{==============================================}
{==============================================}
 Constructor TsListString.Init;
 Begin
  inherited init;
  Napravlenie:=true;
  NachaloList:=Nil;
  TimeList:=Nil;
  KolList:=0;
  buttonlist.init;
 End;
 Procedure   TsListString.SetLongXY;
 Begin
  inherited SetLongXY(x,y);
  buttonlist.setcorxy(longx-longy+cory-1,Cory+1);
  buttonlist.setlongxy(longx-1,longy-1);
  buttonlist.IconXY(longx-longy+cory-1+(longy-cory-8)div 2,cory+2+(longy-cory-8)div 2,Icon8_1);
 End;
 Procedure   TsListString.AddStringList;
 Begin
  new(timelist);
  timelist^.str:=s;
  inc(KolList);
  if NachaloList = nil
     then
     begin
      NachaloList:=timelist;
      NachaloList^.Next:=timelist;
      NachaloList^.Pred:=timelist;
     end
     else
     begin
      NachaloList^.pred^.next:=timelist;
      timelist^.Pred:=NachaloList^.pred;
      timelist^.Next:=NachaloList;
      NachaloList^.Pred:=timelist;
     end;
  timelist:=nil;
 End;
 Procedure   TsListString.OutPutList;
 Var
  i,k : byte;
  fl:boolean;
 Begin
  res.scan.hidecursormouse;
  if Napravlenie
     then
     begin
      barshadow(corx,longy+1,longx,longy+6+(KolList)*10,false,7);
      barshadow(corx+1,longy+2,longx-1,longy+5+(KolList)*10,true,15);
      if NachaloList <> nil then
         begin
          i:=0;
          TimeList:=NachaloList;
          repeat
           if ActivList = (i+1)
              then
              begin
               setfillstyle(1,1);
               Bar(corx+4,longy+4+(i)*10,longx-4,longy+3+(i+1)*10);
               setcolor(15);
              end
              else
               setcolor(res.FontCl);
           outtextxy(corx+5,longy+5+i*10,timelist^.str);
           inc(i);
           TimeList:=TimeList^.next;
          until NachaloList = timelist;
         end;
     end
     else
     begin
      barshadow(corx,cory-6-(KolList)*10,longx,cory-1,false,7);
      barshadow(corx+1,cory-5-(KolList)*10,longx-1,cory-2,true,15);
      if NachaloList <> nil then
         begin
          i:=0;
          TimeList:=NachaloList;
          repeat
           if ActivList = (i+1)
              then
              begin
               setfillstyle(1,1);
               Bar(corx+4,cory-4-(i)*10,longx-4,cory-3-(i+1)*10);
               setcolor(15);
              end
              else
               setcolor(res.FontCl);
           outtextxy(corx+5,cory-12-i*10,timelist^.str);
           inc(i);
           TimeList:=TimeList^.next;
          until NachaloList = timelist;
         end;
     end;
  res.scan.showcursormouse;
 End;
 Procedure   TsListString.RunList;
 Var
  i,k:byte;
  fl:boolean;
  Function PrvZn(nm:byte):boolean;
  Begin
   with res.scan.result do
        if Napravlenie
           then
            if ((corx+3)<x)
               and((longy+3+nm*10)<y)
               and((longx-3)>x)
               and((longy+4+(nm+1)*10)>y)
               then PrvZn:=true
               else PrvZn:=false
           else
            if ((corx+3)<x)
               and((cory-3-(nm+1)*10)<y)
               and((longx-3)>x)
               and((cory-4-nm*10)>y)
               then PrvZn:=true
               else PrvZn:=false;
  End;
 Begin
  OutPutVid:=1;
  Profil:=1;
  OutPut(res);
  res.scan.hidecursormouse;
  setfillstyle(1,15);
  bar(corx+Textx-1,cory+Texty-2,corx+Textx+longvidstr*9-1,cory+Texty+10);
  setcolor(FontCl);
  for k:=1 to length(timelist^.str) do
      outtextxy(corx+Textx+(k-1)*9,cory+Texty,strtemp[k]);
  Buttonlist.OutPutVid:=1;
  Buttonlist.profil:=1;
  Buttonlist.OutPut(res);
  sv.init;
  if Napravlenie
     then sv.copy(corx,longy+1,longx,longy+6+(KolList+1)*10)
     else sv.copy(corx,cory-6-(KolList+1)*10,longx,cory-1);
  res.scan.showcursormouse;
  repeat
   if OutPutVid <> 0 then
      begin
       OutPutList(res);
       OutPutVid:=0;
      end;

   res.scan.run;

   Buttonlist.GetMouse(res);
   Buttonlist.run(res);
   if (res.resultObject = 0) then
      begin
       Activlist:=0;
       TimeList:=nil;
       break;
      end;

   with res.scan.result do
       begin
        if KeyPress then
           begin
            if not(Napravlenie) then
               Case Extendedcode of
                    75,72:Extendedcode:=77;{left}
                    77,80:Extendedcode:=75;{rigt}
               End;
            Case Extendedcode of
                 75,72:{left}
                 begin
                  OutPutVid:=1;
                  profil:=0;
                  case ActivList of
                       0:ActivList:=1;
                       1:ActivList:=KolList;
                       else dec(ActivList);
                  end;
                 end;
                 77,80:{rigt}
                 begin
                  OutPutVid:=1;
                  profil:=0;
                  case ActivList of
                       0:ActivList:=kollist;
                       else
                       if ActivList = KolList
                          then ActivList:=1
                          else inc(ActivList);
                  end;
                 end;
                 71:{home}
                 begin
                  OutPutVid:=1;
                  profil:=0;
                  ActivList:=1;
                 end;
                 79:{end}
                 begin
                  OutPutVid:=1;
                  profil:=0;
                  ActivList:=KolList;
                 end;
            End;
            Case code of
                 13 :
                 begin
                  if ActivList = 0
                     then
                      TimeList:=nil
                     else
                     begin
                      i:=1;
                      TimeList:=NachaloList;
                      repeat
                       if ActivList = i then break;
                       TimeList:=TimeList^.next;
                       inc(i);
                      until NachaloList = timelist;
                     end;
                  break;
                 end;
                 27 :
                 begin
                  TimeList:=nil;
                  ActivList:=0;
                  break;
                 end;
            End;
           end;
        if (((corx)<x)
           and((cory)<y)
           and((longx)>x)
           and((longy+4+(KolList)*10)>y)
           and(Napravlenie))
           or
           (((corx)<x)
           and((cory-4-(KolList)*10)<y)
           and((longx)>x)
           and((longy)>y)
           and(not Napravlenie))
           then
           begin
            if (movecursor)
               then
               begin
                i:=0;
                TimeList:=NachaloList;
                repeat
                 if PrvZn(i)
                    then
                    begin
                     if ActivList = i+1 then break;
                     Activlist:=i+1;
                     outputvid:=1;
                     break;
                    end;
                 TimeList:=TimeList^.next;
                 inc(i);
                until NachaloList = timelist;
               end;
            if click = 1 then
               begin
                i:=0;
                TimeList:=NachaloList;
                repeat
                 if PrvZn(i)
                    then
                     break;
                 TimeList:=TimeList^.next;
                 inc(i);
                until NachaloList = timelist;
                if i < KolList then break;
               end;
           end
           else
           begin
            if click = 1 then
               begin
                TimeList:=nil;
                ActivList:=0;
                break;
               end;
           end;
       end;
  until false;
  res.scan.hidecursormouse;
  if Napravlenie
     then sv.paste(corx,longy+1)
     else sv.paste(corx,cory-6-(KolList+1)*10);
  sv.done;
  res.scan.showcursormouse;
 End;
 Procedure   TsListString.OutPut;
 Begin
  inherited OutPut(res);
  if OutPutVid <> 0
     then
     begin
      Buttonlist.OutPutVid:=1;
      Buttonlist.profil:=0;
      Buttonlist.OutPut(res);
     end;
 End;
 Procedure   TsListString.Run;
 Begin
  with res.scan.result do
  begin
   Buttonlist.GetMouse(res);
   Buttonlist.run(res);
   if (res.resultObject = 1)
      or((nomer = res.focus)and(keypress)and(Extendedcode in [72,80]))
      then
      begin
       if not pravkastr then
          begin
           res.focus:=nomer;
           pravkastr:=true;
           strtemp:=str;
           if strtemp = ''
              then profil:=0
              else profil:=1;
           cr:=length(strtemp);
           if cr > longvidstr
              then crvid:=cr-longvidstr
              else crvid:=0;
          end;
       if Napravlenie
          then
          if Extendedcode = 72
             then ActivList:=KolList{left}
             else ActivList:=1
          else
          if Extendedcode = 80
             then ActivList:=KolList{left}
             else ActivList:=1;
       RunList(res);
       OutPutVid:=1;
       profil:=1;

       if TimeList <> nil
          then
          begin
           StrTemp:=TimeList^.str;
           if not pravka then
              begin
               res.resultobject:=0;
               str:=strtemp;
              end;
           cr:=length(strtemp);
           if cr > longvidstr
              then crvid:=cr-longvidstr
              else crvid:=0;
          end;
       exit;
      end;
  end;
 inherited run(res);
 End;
 Destructor  TsListString.Done;
 Begin
  if NachaloList <> nil then
     begin
      TimeList:=NachaloList^.next;
      while NachaloList <> timelist do
      begin
       NachaloList^.next:=NachaloList^.next^.next;
       dispose(timelist);
       timelist:=NachaloList^.next;
      end;
      dispose(NachaloList);
     end;
  buttonlist.done;
  inherited done;
 End;
{==============================================}
{==============================================}
End.