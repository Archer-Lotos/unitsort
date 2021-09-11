unit unitsort;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ExtCtrls, Grids, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    NViews: TStringGrid;
    Sorting: TButton;
    Nexti: TButton;
    Hag4: TGroupBox;
    Hag3: TGroupBox;
    Hag2: TGroupBox;
    Hag1: TGroupBox;
    gI: TGroupBox;
    gI3: TGroupBox;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    N11: TStringGrid;
    N10: TStringGrid;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SGM: TStringGrid;
    St1: TStringGrid;
    X1Do: TSpinEdit;
    X1Ot: TSpinEdit;
    XX1Do: TSpinEdit;
    XX1Ot: TSpinEdit;
    XX1Otlabel: TLabel;
    Y1Do: TSpinEdit;
    Y1Ot: TSpinEdit;
    YY1Do: TSpinEdit;
    YY1Ot: TSpinEdit;
    Z1Do: TSpinEdit;
    Z1Ot: TSpinEdit;
    ZZ1Do: TSpinEdit;
    ZZ1Ot: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure DrawGrid1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure N10DrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect;
      aState: TGridDrawState);
    procedure NextiClick(Sender: TObject);
    procedure SortingClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;


var
  Form1: TForm1;
  X,Y,Z:Byte;

implementation

{$R *.lfm}

{ TForm1 }

var
  Arr : Array Of Array[1..15,1..3] Of Byte;
  ASList:TStringList;
  ASListTemp:TStringList;
  ArrTab:Array[1..15,1..3] Of Byte;
  ArrDraw:Array[1..15,1..3] Of Byte;
  i: longint;


  {/ ************************************************************************* //
  //
  // Функция   : ss_toDec.
  // Описание  : интерпретация число из строкового представления в бинарное,
  //             в зависимости от указанного основания СС.
  // Параметры : chislo    - число, в строковом представлении;
  //             osnovanie - основание CC в зависимости от которого, строка
  //               интерпретируется.
  /}
  function ss_toDec(chislo : string; osnovanie : byte) : integer;
  const hash_table : string = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  var   otvet : integer;
        p, i  : integer;
  begin
    otvet := 0;
    for i:= 1 to length(chislo) do
    begin
      p := pos(chislo[i], hash_table);
      if p in [1..osnovanie] then
        otvet := (otvet * osnovanie) + (p-1)
      else
      begin
        { нам встретился неверный символ }
        exit;
      end;
    end;
    { возвращаем результат }
    ss_toDec := otvet;
  end; { ss_decTo() }

  {/ ************************************************************************* //
  //
  // Функция   : ss_DecTo.
  // Описание  : конвертирование числа из бинарного в строковое представление
  //             с одновременным конвертированием в указанную СС.
  // Параметры : chislo    - число, бинарном представлении;
  //             osnovanie - основание CC в которую нужно сконвертировать
  //               число.
  /}
  function ss_DecTo(chislo : longint; osnovanie : byte) : string;
  const hash_table : string = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  var   otvet : string;
  begin
    otvet := '';
    while chislo >= osnovanie do
    begin
      otvet  := hash_table[(chislo mod osnovanie)+1] + otvet;
      chislo := chislo div osnovanie;
    end;
    if chislo=osnovanie then
      otvet  := hash_table[chislo] + otvet
    else
      otvet  := hash_table[chislo + 1] + otvet;
    ss_DecTo := otvet;
  end; { ss_decTo() }

procedure TForm1.FormCreate(Sender: TObject);
begin
   X:=6;
   Y:=4;
   Z:=2;
   i:=0;
   Form1.Width:=1195;
   Form1.Height:=625;
   ASList:= TStringList.Create;
   ASListTemp:= TStringList.Create;
end;

procedure TForm1.N10DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  ij: Word;
begin
  N10.Canvas.Brush.Color:=$009B9B9B;
  for ij:=1 to 15 do
      begin
          if(ArrDraw[ij][1]=0) then
            begin
                if ((ACol=0)and(ARow=ij-1)) then
                  N10.Canvas.FillRect(aRect);
            end;
          if(ArrDraw[ij][2]=0) then
            begin
                if ((ACol=1)and(ARow=ij-1)) then
                  N10.Canvas.FillRect(aRect);
            end;
          if(ArrDraw[ij][3]=0) then
            begin
                if ((ACol=2)and(ARow=ij-1)) then
                  N10.Canvas.FillRect(aRect);
            end;
      end;
end;

procedure TForm1.NextiClick(Sender: TObject);
var
  ij: Word;
begin
  i:=i+1;
  SetLength(Arr,i);
  for ij:=1 to 15 do
  begin
     Arr[i-1][ij][1]:= StrToInt(N11.Cells[0,ij-1]);
     Arr[i-1][ij][2]:= StrToInt(N11.Cells[1,ij-1]);
     Arr[i-1][ij][3]:= StrToInt(N11.Cells[2,ij-1]);
  end;
end;

procedure TForm1.SortingClick(Sender: TObject);

  function xcool(stry:string) : integer;
    var
    il1:longint;
    il2:Byte;
    xcc,xc2:Word;
  begin
    xc2:=0;
    If (Length(Arr)>0)then
    for il1:=0 to Length(Arr)-1 do
           begin
              xcc:=0;
              for il2:=1 to 15 do
              begin
                 case StrToInt(stry[il2]) of
                 0:begin
                    if(Arr[il1][il2][1]=1)
                    then inc(xcc);
                 end;
                 1:begin
                    if(Arr[il1][il2][2]=1)
                    then inc(xcc);
                 end;
                 2:begin
                    if(Arr[il1][il2][3]=1)
                    then inc(xcc);
                 end;
                 end;
              end;

              if(xcc>12) then
              begin
                xc2 := xcc;
                Break;
              end;
           end;
    result := xc2;
    //result := 13;
  end;


var
   str:string;
   x1,y1,z1,xx1,yy1,zz1,xc:Word;
   ij:Byte;
   ii,ik,iCount:longint;
   adi:Boolean;
   ArrInc:Array[1..15,1..3] Of longint;

begin
  If (ASList.Count>0)then
        begin

          for ij:=1 to 15 do
              begin
                 if N10.Cells[0,ij-1]='1' then
                     begin
                         ArrTab[ij][1]:=1;
                     end else ArrTab[ij][1]:=0;
                 if N10.Cells[1,ij-1]='1' then
                     begin
                         ArrTab[ij][2]:=1;
                     end else ArrTab[ij][2]:=0;
                 if N10.Cells[2,ij-1]='1' then
                     begin
                         ArrTab[ij][3]:=1;
                     end else ArrTab[ij][3]:=0;
              end;

          for ij:=1 to 15 do
              begin
                   ArrDraw[ij][1]:=0;
                   ArrDraw[ij][2]:=0;
                   ArrDraw[ij][3]:=0;
                   ArrInc[ij][1]:=0;
                   ArrInc[ij][2]:=0;
                   ArrInc[ij][3]:=0;
              end;


              ii:=0;
              iCount:=ASList.Count;
              ASListTemp.Clear;


               while ii < iCount do
               begin
                  adi:=true;
                    for ij:=1 to 15 do
                        begin
                           if (ArrTab[ij][1]=1)or(ArrTab[ij][2]=1)or(ArrTab[ij][3]=1) then
                              case StrToInt(ASList[ii][ij]) of
                                   0:begin
                                      if (ArrTab[ij][1]=0) then
                                      begin
                                        adi:=false;
                                      break;
                                      end;
                                   end;
                                   1:begin
                                      if (ArrTab[ij][2]=0) then
                                      begin
                                      adi:=false;
                                      break;
                                      end;
                                   end;
                                   2:begin
                                      if (ArrTab[ij][3]=0) then
                                      begin
                                      adi:=false;
                                      break;
                                      end;
                                   end;
                              end;

                        end;
                    if adi then ASListTemp.Add(ASList[ii]);
                    inc(ii);
               end;

               ASList.Clear;

               for ii:=0 to ASListTemp.Count-1 do
                    ASList.Add(ASListTemp[ii]);


              for ij:=1 to 15 do
                  begin
                       NViews.Cells[0,ij-1]:='0';
                       NViews.Cells[1,ij-1]:='0';
                       NViews.Cells[2,ij-1]:='0';
                  end;

              for ii:=0 to ASList.Count-1 do
              for ij:=1 to 15 do
                  begin
                             case StrToInt(ASList[ii][ij]) of
                                  0:begin
                                     ArrDraw[ij][1]:=1;
                                     inc(ArrInc[ij][1]);
                                  end;
                                  1:begin
                                     ArrDraw[ij][2]:=1;
                                     inc(ArrInc[ij][2]);
                                  end;
                                  2:begin
                                     ArrDraw[ij][3]:=1;
                                     inc(ArrInc[ij][3]);
                                  end;
                             end;
                  end;

              for ij:=1 to 15 do
                  begin
                     if (ArrDraw[ij][1]=1) then NViews.Cells[0,ij-1]:=IntToStr(ArrInc[ij][1]);
                     if (ArrDraw[ij][2]=1) then NViews.Cells[1,ij-1]:=IntToStr(ArrInc[ij][2]);
                     if (ArrDraw[ij][3]=1) then NViews.Cells[2,ij-1]:=IntToStr(ArrInc[ij][3]);
                  end;

          for ij:=1 to 15 do
              begin
                   N10.Cells[0,ij-1]:=N10.Cells[0,ij-1];
                   N10.Cells[1,ij-1]:=N10.Cells[1,ij-1];
                   N10.Cells[2,ij-1]:=N10.Cells[2,ij-1];
              end;
        end
    else
   begin

   for ik := 0 to 14348906 do
         begin
              xc:=0;
              x1:=0;
              y1:=0;
              z1:=0;
              xx1:=0;
              yy1:=0;
              zz1:=0;

              str:= ss_decTo(ik, 3);
              while Length(str)<15 do
               begin
                 str:='0'+str;
               end;


              if (Length(str)>14) then
               begin

               xc:=0;
               xc:=xcool(str);

               if(xc<13) then
                        begin

                          for ij:=1 to 15 do
                              begin
                                         case StrToInt(str[ij]) of
                                              0:begin
                                                   if(StrToInt(SGM.Cells[0,ij-1])=X)
                                                   then inc(x1);
                                                   if(StrToInt(SGM.Cells[0,ij-1])=Y)
                                                   then inc(y1);
                                                   if(StrToInt(SGM.Cells[0,ij-1])=Z)
                                                   then inc(z1);
                                              end;
                                              1:begin
                                                   if(StrToInt(SGM.Cells[1,ij-1])=X)
                                                   then inc(x1);
                                                   if(StrToInt(SGM.Cells[1,ij-1])=Y)
                                                   then inc(y1);
                                                   if(StrToInt(SGM.Cells[1,ij-1])=Z)
                                                   then inc(z1);
                                              end;
                                              2:begin
                                                   if(StrToInt(SGM.Cells[2,ij-1])=X)
                                                   then inc(x1);
                                                   if(StrToInt(SGM.Cells[2,ij-1])=Y)
                                                   then inc(y1);
                                                   if(StrToInt(SGM.Cells[2,ij-1])=Z)
                                                   then inc(z1);
                                              end;
                                         end;
                              end;

                              if(X1Ot.Value<=x1)AND(x1<=X1Do.Value)
                                 AND(Y1Ot.Value<=y1)AND(y1<=Y1Do.Value)
                                 AND(Z1Ot.Value<=z1)AND(z1<=Z1Do.Value)
                                 then
                                     begin
                                         for ij:=1 to 15 do
                                         begin
                                              case StrToInt(str[ij]) of
                                                   0:begin
                                                      if (StrToInt(St1.Cells[0,ij-1])=StrToInt(SGM.Cells[0,ij-1]))
                                                         then
                                                             begin
                                                                if (StrToInt(St1.Cells[0,ij-1])=X) then inc(xx1);
                                                                if (StrToInt(St1.Cells[0,ij-1])=Y) then inc(yy1);
                                                                if (StrToInt(St1.Cells[0,ij-1])=Z) then inc(zz1);
                                                             end;
                                                   end;

                                                   1:begin
                                                      if (StrToInt(St1.Cells[0,ij-1])=StrToInt(SGM.Cells[1,ij-1]))
                                                         then
                                                             begin
                                                                if (StrToInt(St1.Cells[0,ij-1])=X) then inc(xx1);
                                                                if (StrToInt(St1.Cells[0,ij-1])=Y) then inc(yy1);
                                                                if (StrToInt(St1.Cells[0,ij-1])=Z) then inc(zz1);
                                                             end;
                                                   end;

                                                   2:begin
                                                      if (StrToInt(St1.Cells[0,ij-1])=StrToInt(SGM.Cells[2,ij-1]))
                                                         then
                                                             begin
                                                                if (StrToInt(St1.Cells[0,ij-1])=X) then inc(xx1);
                                                                if (StrToInt(St1.Cells[0,ij-1])=Y) then inc(yy1);
                                                                if (StrToInt(St1.Cells[0,ij-1])=Z) then inc(zz1);
                                                             end;
                                                   end;
                                              end;
                                         end;

                                         if((YY1Ot.Value<=yy1)AND(yy1<=YY1Do.Value)
                                         AND(XX1Ot.Value<=xx1)AND(xx1<=XX1Do.Value)
                                         AND(ZZ1Ot.Value<=zz1)AND(zz1<=ZZ1Do.Value))
                                           then
                                               begin
                                                 ASList.Add(str);
                                               end;
                                     end;
                        end;
              end;
         end;
    Sorting.Click;
   end;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
   fs:textFile;
   filesave:string;

   ii:LongInt;
begin

If (ASList.Count>0)then
      begin
        If (SaveDialog1.Execute) then
          begin
            filesave := SaveDialog1.FileName;
            AssignFile(fs, filesave);
            Rewrite(fs);

            for ii:=0 to ASList.Count-1 do
            writeln(fs, ASList[ii]);

            CloseFile(fs);
          end;
      end;
end;

procedure TForm1.DrawGrid1Click(Sender: TObject);
begin

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SetLength(Arr,0);
end;

end.

