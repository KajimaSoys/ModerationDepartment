unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  DBAccess, PgAccess, MemDS, Vcl.ComCtrls, Vcl.Buttons, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Imaging.jpeg;

type
  TForm3 = class(TForm)
    StatusBar1: TStatusBar;
    ADOConnection1: TADOConnection;
    DataSource1: TDataSource;
    ADODataSet1: TADODataSet;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    DBText1: TDBText;
    DBText3: TDBText;
    DBText4: TDBText;
    startButton: TButton;
    finishButton: TButton;
    refreshButton: TButton;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RadioGroup1: TRadioGroup;
    contentJar: TImage;
    sendButton: TButton;
    Label2: TLabel;
    DBText2: TDBText;
    ADOQuery1: TADOQuery;
    Label5: TLabel;
    DBGrid1: TDBGrid;
    ADODataSet2: TADODataSet;
    DataSource2: TDataSource;
    Label6: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure startButtonClick(Sender: TObject);
    procedure finishButtonClick(Sender: TObject);
    procedure refreshButtonClick(Sender: TObject);
    procedure sendButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

function queryCreator(id,rg1:Integer): string;
var solution: Integer;
    nowtime,queryStr: String;
begin
  nowtime:=DateToStr(Date);
  solution:=rg1+1;
  queryStr:='UPDATE public.jobs SET date_of_execution= '''+nowtime+''', id_solution='+inttostr(solution)+', id_executor=1 WHERE id='+inttostr(id)+';';
  result:=queryStr;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
    if DBGrid1.DataSource.DataSet.Locate(DBGrid1.Columns[1].FieldName, Edit1.Text,[loCaseInsensitive, loPartialKey]) then
      DBGrid1.DataSource.DataSet.Locate('first_name', Edit1.Text,[loCaseInsensitive, loPartialKey]);
    if not ADODataSet2.Locate('first_name', Edit1.Text,[loCaseInsensitive, loPartialKey]) then
      ShowMessage('Запись не найдена');
end;

procedure TForm3.finishButtonClick(Sender: TObject);
begin
  startButton.Enabled:=True;
  finishButton.Enabled:=False;
  refreshButton.Enabled:=False;
  contentJar.Visible:=False;
  Label1.Visible:=False;
  Label2.Visible:=False;
  Label3.Visible:=False;
  Label4.Visible:=False;
  DBText1.Visible:=False;
  DBText2.Visible:=False;
  DBText3.Visible:=False;
  DBText4.Visible:=False;
  RadioGroup1.Visible:=False;
  sendButton.Visible:=False;
  ADODataSet1.Active:=False;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ADOConnection1.Connected:=False;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  contentJar.Visible:=False;
  Label1.Visible:=False;
  Label2.Visible:=False;
  Label3.Visible:=False;
  Label4.Visible:=False;
  Label5.Visible:=False;
  DBText1.Visible:=False;
  DBText2.Visible:=False;
  DBText3.Visible:=False;
  DBText4.Visible:=False;
  RadioGroup1.Visible:=False;
  sendButton.Visible:=False;
  if ADOConnection1.Connected=True then
    StatusBar1.Panels[0].Text := 'Подключение успешно'
end;


procedure TForm3.refreshButtonClick(Sender: TObject);
begin
  ADODataSet1.Active:=False;
  ADODataSet1.Active:=True;
  //ADODataSet1.CommandText:='SELECT * FROM public.jobs WHERE jobs.id_solution is NULL ORDER BY RANDOM() LIMIT 1';
end;

procedure TForm3.sendButtonClick(Sender: TObject);
var queryString: String;
begin
  queryString:=queryCreator(ADODataSet1.FieldByName('id').AsInteger,RadioGroup1.ItemIndex);
  //ADODataSet2.CommandText:=queryString;
  //ADODataSet2.Active:=False;
  //ADODataSet2.Active:=True;
  //Label5.Caption:=queryString;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add(queryString);
  ADOQuery1.ExecSQL;
  ADODataSet1.Active:=False;
  ADODataSet1.Active:=True;
  if ADODataSet1.RecordCount=0 then
    begin
      finishButtonClick(Form3);
      Label5.Visible:=True;
    end;
end;

procedure TForm3.startButtonClick(Sender: TObject);
begin
  startButton.Enabled:=False;
  finishButton.Enabled:=True;
  refreshButton.Enabled:=True;
  contentJar.Visible:=True;
  Label1.Visible:=True;
  Label2.Visible:=True;
  Label3.Visible:=True;
  Label4.Visible:=True;
  DBText1.Visible:=True;
  DBText2.Visible:=True;
  DBText3.Visible:=True;
  DBText4.Visible:=True;
  RadioGroup1.Visible:=True;
  sendButton.Visible:=True;
  ADODataSet1.Active:=True;
  if ADODataSet1.RecordCount=0 then
    begin
      finishButtonClick(Form3);
      Label5.Visible:=True;
    end;
end;

end.
