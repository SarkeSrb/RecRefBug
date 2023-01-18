report 50100 "TestRecordRefsBug"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'RecRefBug';
    UseRequestPage = false;

    trigger OnInitReport()
    var
        RecRefBug: Codeunit RecRefBug;
    begin
        RecRefBug.Run();
    end;
}