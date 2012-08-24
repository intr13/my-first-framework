Unit OpenGrap;

Interface
 Uses dos,Graph,tpcrt;
 Const
  GrDr       : integer = detect;
  GrMd       : integer = 0;{гpафический дpайвеp ,pежим}
  PathDrv    : string  = '';
  ErrorsMode : boolean = false;
  maxx       : word = 640;
  maxy       : word = 480;
  maxsave    = 38400;
 Type
  ScrenGraph = Object
             Ptr  : pointer;
             Size : word;
             Put  : byte;
                    {0 - copyput
                     1 - xorput
                     2 - orput
                     3 - andput
                     4 - notput
                    }
             Constructor Init;
             Procedure   SetPut(p:byte);
             Procedure   Copy(x1,y1,x2,y2:word);
             Procedure   Paste(x,y:word);
             Destructor  Done;
  End;

 Procedure ScrenSave(name:string);

 Procedure ScrenRestore(name:string);

 Procedure ScrenDelete(name:string);

 Procedure OpenGraphMode;

 Procedure CloseGraphMode;

 Procedure DoubleLine(x1,y1,x2,y2:word);

 Procedure BarShadow(x1,y1,x2,y2:word;{кооpдинаты пpямоугольника}
                     Gora:boolean;    {true-пpямоугольник выпуклый,false-пpямоугольник впуклый(невыпуклый)}
                     FonColor:byte);  {цвет фона}

 Procedure BarPrerLine(x1,y1,x2,y2:word;{кооpдинаты пpямоугольника}
                       LineColor:byte);  {цвет линий}

 Procedure FormBar(x1,y1,x2,y2:word;{кооpдинаты пpямоугольника}
                   H:byte;{высота полоски}
                   ColorFon:byte;
                   ColorPolos:byte;
                   shadow:boolean);

Implementation

 Procedure errors;
 Begin
  if GraphResult <> 0
     then
      ErrorsMode:=false
     else
      ErrorsMode:=true
 End;

 Procedure OpenGraphMode;
 Begin
  {$i-}
  InitGraph(GrDr,GrMd,PathDrv);
  errors;
  MaxX:=GetMaxX;
  MaxY:=GetMaxY;
  {$i+}
 End;

 Procedure CloseGraphMode;
 Begin
  {$i-}
  CloseGraph;
  errors;
  {$i+}
 End;

 Procedure DoubleLine(x1,y1,x2,y2:word);
 Begin
  line(x1,y1,x1,y2);
  line(x2,y1,x2,y2);
  line(x1,y1,x2,y1);
  line(x1,y2,x2,y2);

  line(x1+2,y1+2,x1+2,y2-2);
  line(x2-2,y1+2,x2-2,y2-2);
  line(x1+2,y1+2,x2-2,y1+2);
  line(x1+2,y2-2,x2-2,y2-2);
 End;
 Constructor ScrenGraph.Init;
 Begin
  Ptr:=nil;
  Size:=0;
  put:=0;
 End;
 Procedure ScrenGraph.Copy;
 Begin
  if Size > 0
     then
     begin
      freemem(ptr,Size);
      ptr:=nil;
      Size:=0;
     end;
  Size:=imagesize(x1,y1,x2,y2);
  GetMem(ptr,size);
  getimage(x1,y1,x2,y2,ptr^);
 End;
 Procedure ScrenGraph.SetPut;
 Begin
  put:=p;
 End;
 Procedure ScrenGraph.Paste;
 Begin
  PutImage(x,y,ptr^,Put);
 End;
 Destructor ScrenGraph.Done;
 Begin
  if Size > 0
     then
     begin
      freemem(ptr,Size);
      ptr:=nil;
      Size:=0;
     end;
 End;
 Procedure BarShadow;
 Begin
  setfillstyle(1,FonColor);
  bar(x1,y1,x2,y2);
  if Gora
     then
     begin
      SetColor(0);
      line(x1,y1,x1,y2);
      line(x1,y1,x2,y1);
      setcolor(15);
      line(x1,y2,x2,y2);
      line(x2,y1,x2,y2);
     end
     else
     begin
      SetColor(15);
      line(x1,y1,x1,y2);
      line(x1,y1,x2,y1);
      setcolor(0);
      line(x1,y2,x2,y2);
      line(x2,y1,x2,y2);
     end;
 End;
 Procedure BarPrerLine;
 Var
  i:word;
  fl:boolean;
 Begin
  fl:=false;
  for i:=x1 to x2 do
      if fl
         then
         begin
          putpixel(i,y1,LineColor);
          putpixel(i,y2,LineColor);
          fl:=false;
         end
         else
          fl:=true;
  fl:=false;
  for i:=y1 to y2 do
      if fl
         then
         begin
          putpixel(x1,i,LineColor);
          putpixel(x2,i,LineColor);
          fl:=false;
         end
         else
          fl:=true;
 End;
 Procedure FormBar;
 Begin
  if shadow
     then
      barshadow(x1,y1,x2,y2,false,colorfon)
     else
     begin
      setfillstyle(1,colorfon);
      bar(x1,y1,x2,y2);
     end;
  setfillstyle(1,colorpolos);
  bar(x1+2,y1+2,x2-2,y1+2+H);
 End;
 Procedure ScrenSave;
 Var
  s     : file;
  res   : searchrec;
  i     : byte;
  r: word;
 Begin
  assign(s,'savetemp\'+name+'.sav');
  {$i-}
  rewrite(s,1);
  Case ioresult of
       0:;
       3:
       begin
        MkDir('savetemp');
        rewrite(s,1);
       end;
       else
        exit;
  End;
  {$i+}
  port[$3CE]:=4;
  for i:=3 downto 0 do
      begin
       port[$3CF]:=i;
       BlockWrite(s,mem[segA000:$0000],maxsave,r);
      end;
  close(s);
 End;
 Procedure ScrenRestore;
 Var
  S     : file;
  j     : byte;
 Begin
  assign(s,'savetemp\'+name+'.sav');
  {$i-}
  reset(s,1);
  if ioresult <> 0 then exit;
  {$i+}
  j:=getmaxx;
  j:=getmaxy;
  port[$03C4]:=2;
  j:=8;
  repeat
   port[$03C5]:=j;
   BlockRead(s,mem[segA000:$0000],maxsave);
   j:=j shr 1;
  until j=0;
  close(s);
  port[$03C5]:=$0F;
 End;
 Procedure ScrenDelete;
 Var
  S : file;
  res :searchrec;
 Begin
  assign(s,'savetemp\'+name+'.sav');
  {$i-}
  erase(s);
  if ioresult <> 0 then exit;
  {$i+}
  chdir('savetemp');
  findfirst('*.*',anyfile,res);
  if res.name = '.' then
     begin
      findnext(res);
      findnext(res);
     end;
  chdir('..');
  if doserror <> 0
     then RmDir('savetemp');
 End;

End.