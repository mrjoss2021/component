unit cportled;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CPort, Grids, DB, DBTables;

type
  TForm1 = class(TForm)
    Button3: TButton;
    Button4: TButton;
    ComPort1: TComPort;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    enik: TEdit;
    Button1: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Memo1: TMemo;
    ComDataPacket1: TComDataPacket;
    StringGrid1: TStringGrid;
    Query1: TQuery;
    BtnSimpan: TButton;
    Query2: TQuery;
    btninsert: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComDataPacket1Packet(Sender: TObject; const Str: String);
    procedure Button1Click(Sender: TObject);
    procedure BtnSimpanClick(Sender: TObject);
    procedure btninsertClick(Sender: TObject);
  private
    function explode(separator, a: String): TStringList;
    procedure ShowGrid(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  hasil:string;
 i,bar:integer;
 s:string;
implementation

{$R *.dfm}

procedure TForm1.ShowGrid(Sender: TObject);
begin
StringGrid1.ColCount:=4;
StringGrid1.RowCount:=2;
  StringGrid1.Cells[0,0]:='NIP';
  StringGrid1.Cells[1,0]:='BERAT BADAN';
  StringGrid1.Cells[2,0]:='TINGGI BADAN';
  StringGrid1.Cells[3,0]:='LINGKAR KEPALA';
  StringGrid1.ColWidths[0]:=100;
  StringGrid1.ColWidths[1]:=120;
  StringGrid1.ColWidths[2]:=120;
  StringGrid1.ColWidths[3]:=120;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
ComPort1.ShowSetupDialog;
end;

procedure TForm1.Button4Click(Sender: TObject );
begin
ShowGrid(Sender);
hasil:='';
s:='';
i:=0;
bar:=1;
  if Button4.Caption = 'START' then
  begin
    Button4.Caption := 'STOP';
    comport1.Open;
  end
  else if Button4.Caption = 'STOP' then
  begin
    Button4.Caption := 'START';
    comport1.Close;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
close;
end;


function TForm1.explode(separator, a: String) :TStringList;
var
  i : Integer;
  item : String;
begin
  result := TStringList.Create();

  i := pos(separator, a);
  while i > 0 do begin
    item := copy(a, 0, i-1);
    item := trim(item);
    result.Add(item);
    a := copy(a, i+length(separator), length(a));
    i := pos(separator, a);
  end;
  if a <> '' then
    result.Add(trim(a));
end;

procedure TForm1.ComDataPacket1Packet(Sender: TObject; const Str: String);
var
s1,s2,s3:string;
 lis:tstringlist;
 tinggi,bb,LK:real;
begin
if pos('#',str)>0 then i:=i+1;
    hasil:=hasil+trim(Str);
     hasil:=StringReplace(hasil,#13+#10,'',[rfReplaceAll]);
     hasil:=StringReplace(hasil,'#','',[rfReplaceAll]);
if i =3 then
begin

//  hasil=*0#*100.00#*94.20#
{
0
100.00
94.20
}
 //parsing
 lis:=tstringlist.Create;
 lis.AddStrings(explode('*',hasil));
  s1:=lis[1];
  s2:=lis[2];
  s3:=lis[3];
    StringGrid1.Cells[0,bar]:=enik.Text;
   StringGrid1.Cells[1,bar]:=S1;
    StringGrid1.Cells[2,bar]:=S2;
    StringGrid1.Cells[3,bar]:=S3;
  tinggi:=strtofloatdef(s2,0);
  bb:=strtofloatdef(s1,0);
 lk:=strtofloatdef(s3,0);
  label1.Caption:=s1;
  label2.Caption:=s2;
  label3.Caption:=s3;
  lis.Free;
 Memo1.Lines.add('nilai i '+inttostr(i)+' : '+hasil);
 Memo1.Lines.add('tinggi '+ Format('%.2n',[tinggi]));
 Memo1.Lines.add('bb '+ Format('%.2n',[bb]));
 Memo1.Lines.add('lk '+ Format('%.2n',[lk]));

 hasil:='';
 i:=0;
 bar:=bar+1;
 StringGrid1.RowCount:=StringGrid1.RowCount+1;
end;
 end;
procedure TForm1.Button1Click(Sender: TObject);
begin
Query1.Close;
Query1.SQL.Text:='select * from pengukuran1' ;
Query1.Open;
enik.Text:=Query1.fieldbyname('nik').AsString;
end;

procedure TForm1.BtnSimpanClick(Sender: TObject);
var
bb,tb,lk:real;
nik:string;
begin
nik:=stringgrid1.Cells[0,1];
bb:=strtofloatdef(stringgrid1.Cells[1,1],0);
tb:=strtofloatdef(stringgrid1.Cells[2,1],0);
lk:=strtofloatdef(stringgrid1.Cells[3,1],0);
  Query2.Close;
Query2.SQL.Text:='update pengukuran1 set '+
' tgl=:tgl ,' +
' berat_badan=:berat_badan ,' +
' tinggi_badan=:tinggi_badan, ' +
' lingkar_kepala=:lingkar_kepala ' +
' where nik=:nik';

Query2.ParamByName('tgl').AsDateTime:=now();
Query2.ParamByName('berat_badan').AsFloat:=bb;
Query2.ParamByName('tinggi_badan').AsFloat:=tb;
Query2.ParamByName('lingkar_kepala').AsFloat:=lk;
Query2.ParamByName('nik').Asstring:=nik;
Query2.ExecSQL;
showmessage('data sudah disimpan');
end;

procedure TForm1.btninsertClick(Sender: TObject);
var
tb,lk:real;
nik:string;
bb:integer;
begin
nik:=stringgrid1.Cells[0,1];
showmessage(stringgrid1.Cells[1,1]);
bb:=strtointdef(stringgrid1.Cells[1,1],0);
tb:=strtofloatdef(stringgrid1.Cells[2,1],0);
lk:=strtofloatdef(stringgrid1.Cells[3,1],0);
  Query2.Close;
Query2.SQL.Text:='insert into pengukuran1 '+
'(tgl,nik,berat_badan,tinggi_badan,lingkar_kepala) '+
' values '+
'(:tgl,:nik,:berat_badan,:tinggi_badan,:lingkar_kepala) ';

Query2.ParamByName('tgl').AsDateTime:=now();
Query2.ParamByName('berat_badan').asinteger:=bb;
Query2.ParamByName('tinggi_badan').AsFloat:=tb;
Query2.ParamByName('lingkar_kepala').AsFloat:=lk;
Query2.ParamByName('nik').Asstring:=nik;
Query2.ExecSQL;
showmessage('data sudah disimpan');
end;


end.