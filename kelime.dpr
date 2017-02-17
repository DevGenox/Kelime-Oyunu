program kelime;

uses
  Vcl.Forms,
  kelimeoyunu in 'kelimeoyunu.pas' {Form2},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Metropolis UI Blue');
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
