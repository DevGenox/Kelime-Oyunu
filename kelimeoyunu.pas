unit kelimeoyunu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.Imaging.pngimage;

type
  TForm2 = class(TForm)
    kelimetxtbox: TEdit;
    Timer1: TTimer;
    Timer2: TTimer;
    kolay_btn: TButton;
    normal_btn: TButton;
    zor_btn: TButton;
    geri_btn: TButton;
    score_txt: TStaticText;
    can_txt: TLabel;
    gameOver_txt: TLabel;
    isim_txt: TLabel;
    isim_txtbox: TEdit;
    resultScore_txt: TLabel;
    scoreSave_btn: TButton;
    retry_btn: TButton;
    logo_img: TImage;
    scoreTableGeri_btn: TButton;
    scoreTable_img: TImage;
    ayarlar_img: TImage;
    cikis_img: TImage;
    oyna_img: TImage;
    gameover_img: TImage;
   // player :
    procedure Timer1Timer(Sender: TObject);
    procedure kelimetxtboxKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure oyna_imgClick(Sender: TObject);
    procedure geri_btnClick(Sender: TObject);
    procedure kolay_btnClick(Sender: TObject);
    procedure normal_btnClick(Sender: TObject);
    procedure zor_btnClick(Sender: TObject);
    procedure scoreTable_imgClick(Sender: TObject);
    procedure scoreSave_btnClick(Sender: TObject);
    procedure retry_btnClick(Sender: TObject);
    procedure cikis_imgClick(Sender: TObject);
    procedure scoreTableGeri_btnClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;
  playerCL = class
    public
     name : string;
     skor : integer;
     kill: integer;
     dif : string;
   end;
var
  Form2: TForm2;
  kelimeler: array[0..81741] of string;
  wordList:TStringList;
  texts:array of TStaticText;
  scoreGrid : TStringGrid;
  nextMonster : Integer;
  formHeight: Double;
  textHeight: Double;
  playerList : TList;
  kelimeList: TextFile;
  scoreList: TextFile;
  LineCount: Integer;
  LineNow: Extended;
  player : playerCL;
  zorluk : Integer;
  score : Integer;
  can : Integer;
  killedWords : Integer;
  zorlukIsim : string;
implementation

{$R *.dfm}

uses ScoreTable;
procedure DeleteTextX(const Index: Integer);
var
  ALength: integer;
  i: Cardinal;
begin
  ALength := Length(texts);
  Assert(ALength > 0);
  Assert(Index < ALength);
  for i := Index + 1 to ALength - 1 do
    texts[i - 1] := texts[i];
  SetLength(texts, ALength - 1);
end;

procedure TForm2.oyna_imgClick(Sender: TObject);
begin
kolay_btn.Visible := true;
normal_btn.Visible := true;
zor_btn.Visible := true;
geri_btn.Visible := true;


oyna_img.Visible := false;
ayarlar_img.Visible := false;
cikis_img.Visible := false;
scoreTable_img.Visible := false;
end;

procedure TForm2.scoreSave_btnClick(Sender: TObject);
begin
AssignFile(scoreList,'Scores.txt');
if FileExists('Scores.txt') then Append(scoreList)
else
Rewrite(scoreList);

Writeln(scoreList, isim_txtbox.Text);
Writeln(scoreList, inttostr(score));
Writeln(scoreList, inttostr(killedWords));
Writeln(scoreList, zorlukIsim);

closeFile(scoreList);
end;
function sortfunction(a : Pointer; b : Pointer) : Integer;
var
  item1,item2 : PlayerCL;
begin

item1 := PlayerCL(a);
item2 := PlayerCL(b);

Result := item2.skor - item1.skor;
end;

procedure TForm2.scoreTableGeri_btnClick(Sender: TObject);
begin
scoreGrid.Visible := false;
scoreTableGeri_btn.Visible := false;



oyna_img.Visible := true;
ayarlar_img.Visible := true;
cikis_img.Visible := true;
scoreTable_img.Visible := true;
logo_img.Visible := true;
end;

procedure TForm2.scoreTable_imgClick(Sender: TObject);
var
name,score,killed,dif: string;
nowRow: integer;
scoreItem : array of string;
i : integer;
begin
oyna_img.Visible := false;
ayarlar_img.Visible := false;
cikis_img.Visible := false;
scoreTable_img.Visible := false;
logo_img.Visible := false;

scoreTableGeri_btn.Visible := true;

scoreGrid := TStringGrid.Create(Self);
scoreGrid.parent:=Self;

scoreGrid.Left := 122;
scoreGrid.Top := 50;

scoreGrid.RowCount := 1;
scoreGrid.ColCount := 6;

scoreGrid.ColWidths[0] := 27;

ScoreGrid.Cells[0,0] := 'Sýra';
ScoreGrid.Cells[1,0] := 'Ýsimler';
ScoreGrid.Cells[2,0] := 'Puanlar';
ScoreGrid.Cells[3,0] := 'Kelime Sayýsý';
ScoreGrid.Cells[4,0] := 'Zorluk Seviyesi';
ScoreGrid.Cells[5,0] := 'Süre';


scoreGrid.Height := 240;
scoreGrid.Width := 356;

scoreGrid.enabled:=true;
scoreGrid.show;


AssignFile(scoreList,'Scores.txt');

Reset(scoreList);

playerList := TList.Create();

while Not eof(scoreList) do
begin



Readln(scoreList,name);
Readln(scoreList,score);
Readln(scoreList,killed);
Readln(scoreList,dif);

player := playerCL.Create();
player.name := name;
player.skor := StrToInt(score);
player.kill := StrToInt(killed);
player.dif := dif;

PlayerList.Add(player);


end;

playerList.Sort(sortfunction);

for i := 0 to playerList.Count-1 do
begin
scoreGrid.RowCount := scoreGrid.RowCount + 1;
scoreGrid.Cells[0,scoreGrid.RowCount - 1] := inttostr(i + 1);
scoreGrid.Cells[1,scoreGrid.RowCount - 1] := playerCL(playerList[i]).name;
scoreGrid.Cells[2,scoreGrid.RowCount - 1] := inttoStr(playerCL(playerList[i]).skor);
scoreGrid.Cells[3,scoreGrid.RowCount - 1] := inttoStr(playerCL(playerList[i]).kill);
scoreGrid.Cells[4,scoreGrid.RowCount - 1] := playerCL(playerList[i]).dif;
end;

scoreGrid.Left :=  Round((Screen.Width / 2) - (scoreGrid.Width / 2));


end;
function StringListFromStrings(const Strings: array of string): TStringList;
var
  i: Integer;
begin
  Result := TStringList.Create;
  for i := low(Strings) to high(Strings) do
    Result.Add(Strings[i]);
end;
procedure Shuffle(Strings: TStringList);
var
  i: Integer;
begin
  for i := Strings.Count-1 downto 1 do
    Strings.Exchange(i, Random(i+1));
end;


procedure TForm2.cikis_imgClick(Sender: TObject);
begin
halt;
end;

procedure TForm2.FormCreate(Sender: TObject);
var i : Integer;
centerScreen : Integer;
begin

  WindowState := wsMaximized;

  centerScreen := Round((Screen.Width / 2));

  scoreTable_img.Left := centerScreen - Round((scoreTable_img.Width / 2));
  logo_img.Left := centerScreen - Round((logo_img.Width / 2));
  oyna_img.Left := centerScreen - Round((oyna_img.Width / 2));
  ayarlar_img.Left := centerScreen - Round((ayarlar_img.Width / 2));
  cikis_img.Left := centerScreen - Round((cikis_img.Width / 2));

  kolay_btn.Left := centerScreen - Round((kolay_btn.Width / 2));
  normal_btn.Left := centerScreen - Round((normal_btn.Width / 2));
  zor_btn.Left := centerScreen - Round((zor_btn.Width / 2));
  geri_btn.Left := centerScreen - Round((geri_btn.Width / 2));

  kelimetxtbox.Top := Screen.Height - 100;
  can_txt.Top := Screen.Height - 100;
  score_txt.Top := Screen.Height - 100;

  gameOver_img.Left := centerScreen - Round((gameOver_img.Width / 2));
  isim_txt.Left := centerScreen - Round((isim_txt.Width / 2)) - 100;
  isim_txtbox.Left := centerScreen - Round((isim_txtbox.Width / 2));
  resultScore_txt.Left := centerScreen - Round((resultScore_txt.Width / 2));
  retry_btn.Left := centerScreen - Round((retry_btn.Width / 2));
  scoreSave_btn.Left := centerScreen - Round((scoreSave_btn.Width / 2));



  scoreTableGeri_btn.Left := centerScreen - Round((scoreTableGeri_btn.Width / 2));

  LineCount := 0;
  AssignFile(kelimeList,'TDK.txt');
  Reset(kelimeList);


  while not Eof(kelimeList) do
  begin

  Readln(kelimeList,kelimeler[LineCount]);
  LineCount := LineCount + 1;
  end;


  //ShowMessage('ilk satýr = ' +kelimeler[0]);
  CloseFile(kelimeList);
  wordList := StringListFromStrings(kelimeler);
  Shuffle(wordList);
  SetLength(texts,81741);



end;

procedure TForm2.geri_btnClick(Sender: TObject);
begin

kolay_btn.Visible := false;
normal_btn.Visible := false;
zor_btn.Visible := false;
geri_btn.Visible := false;


oyna_img.Visible := true;
ayarlar_img.Visible := true;
cikis_img.Visible := true;
scoreTable_img.Visible := true;
logo_img.Visible := true;

end;

procedure TForm2.kelimetxtboxKeyPress(Sender: TObject; var Key: Char);
var i : Integer;
begin

  if ord(Key) = VK_RETURN then
  begin
  for i := 0 to Length(texts) - 1 do
  begin
  if Not (texts[i] = nil) then
  begin
  if kelimetxtbox.Text = texts[i].Caption then
  begin
  score := score + (10 * Length(texts[i].Caption));
  score_txt.Caption := IntToStr(score);
  killedWords := killedWords + 1;

  texts[i].Destroy;
  kelimetxtbox.Text := '';
  DeleteTextX(i);

  end;
  end;
  end;
  kelimetxtbox.Text := '';
  end;


end;



procedure TForm2.kolay_btnClick(Sender: TObject);
begin
zorluk := 6000;
zorlukIsim := 'kolay';
can:=10;
can_txt.Caption := can_txt.Caption + inttostr(can);
  score_txt.Caption := '0';

kolay_btn.Visible := false;
normal_btn.Visible := false;
zor_btn.Visible := false;
geri_btn.Visible := false;
logo_img.Visible := false;

Timer1.Enabled := true;
Timer2.Enabled := true;
can_txt.Visible := true;

kelimetxtbox.Visible := true;
kelimetxtbox.SetFocus;
end;

procedure TForm2.normal_btnClick(Sender: TObject);
begin
zorluk := 4000;
zorlukIsim := 'normal';
can:=10;
can_txt.Caption := can_txt.Caption + inttostr(can);
score_txt.Caption := '0';

kolay_btn.Visible := false;
normal_btn.Visible := false;
zor_btn.Visible := false;
geri_btn.Visible := false;
logo_img.Visible := false;

Timer1.Enabled := true;
Timer2.Enabled := true;
can_txt.Visible := true;

kelimetxtbox.Visible := true;
kelimetxtbox.SetFocus;
end;

procedure TForm2.zor_btnClick(Sender: TObject);
begin
zorluk := 2000;
zorlukIsim := 'zor';
can:=10;
can_txt.Caption := can_txt.Caption + inttostr(can);
  score_txt.Caption := '0';

kolay_btn.Visible := false;
normal_btn.Visible := false;
zor_btn.Visible := false;
geri_btn.Visible := false;
logo_img.Visible := false;

Timer1.Enabled := true;
Timer2.Enabled := true;
can_txt.Visible := true;

kelimetxtbox.Visible := true;
kelimetxtbox.SetFocus;
end;

procedure TForm2.retry_btnClick(Sender: TObject);
begin
  gameOver_img.Visible := false;
  isim_txt.Visible := false;
  isim_txtbox.Visible := false;
  resultScore_txt.Visible := false;
  scoreSave_btn.Visible := false;
  retry_btn.Visible := false;

  score_txt.Visible := true;
  can_txt.Visible := true;

  can:=10;
  score := 0;
  killedWords :=0;

  can_txt.Caption := 'Can = 10' ;
  score_txt.Caption := '0';

  SetLength(texts,81741);

  Shuffle(wordList);

  nextMonster := 0;

  timer2.Enabled := true;
  timer1.Enabled := true;

  kelimetxtbox.SetFocus;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
var i : Integer;
begin
if Not (Length(texts)= 0) then
begin
if can = 0 then
begin
  gameOver_img.Visible := true;
  isim_txt.Visible := true;
  isim_txtbox.Visible := true;
  resultScore_txt.Visible := true;
  scoreSave_btn.Visible := true;
  retry_btn.Visible := true;

  score_txt.Visible := false;
  can_txt.Visible := false;

  resultScore_txt.Caption := 'Score = ' + inttostr(score);



  timer2.Enabled := false;


  for i := 0 to Length(texts) - 1 do
  begin
  if Not (texts[i] = nil) then
  begin
  texts[i].Destroy;
  DeleteTextX(i);
  end;
  end;
  timer1.Enabled := false;
end;
for i := 0 to Length(texts) - 1 do
begin
if Not (texts[i] = nil) then
begin
 texts[i].Left := texts[i].Left + 1 ;
if texts[i].Left > 400 then
begin
texts[i].ParentColor := false;
texts[i].Font.Color := clYellow;
end;
if texts[i].Left >= kelimeoyunu.Form2.Width then
 begin
 texts[i].Destroy;
 DeleteTextX(i);
 can := can - 1;
 can_txt.Caption := 'Can = ' + inttostr(can);

 end;
end;

end;




end;
end;

procedure TForm2.Timer2Timer(Sender: TObject);
var i : integer;
begin


   if nextMonster <= Length(texts) - 1 then
   begin
   texts[nextMonster] := TStaticText.Create(Self);
   texts[nextMonster].parent:=Self;

   if WindowState = wsMaximized then
   begin
   texts[nextMonster].top:=Random(Screen.Height - 200);
   texts[nextMonster].left:= Random(100);
   end;

  { if Length(texts) >= 2 then
   begin
   for i := 1 to Length(texts) - 1 do
   begin
   if texts[nextMonster].Left < texts[i].Left + 50  then texts[nextMonster].Left := texts[i].Left + 70
   end;
   end;
   }


   texts[nextMonster].height:=50;
   texts[nextMonster].width:=50;

   texts[nextMonster].Font.Name := 'Times New Roman';
  // texts[nextMonster].Font.Color := clYellow;
   texts[nextMonster].Font.Size := 12;
   texts[nextMonster].Font.Style := [fsBold];

   texts[nextMonster].enabled:=true;
   texts[nextMonster].show;

   texts[nextMonster].Caption:=wordList[nextMonster];

   Timer2.Interval := Random(zorluk)
  end;
   nextMonster := nextMonster + 1;
end;




end.
