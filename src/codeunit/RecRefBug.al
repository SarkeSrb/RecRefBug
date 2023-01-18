codeunit 50100 "RecRefBug"
{
    trigger OnRun()
    begin
        IterateWithRecRef();
    end;

    procedure IterateWithRecRef()
    var
        RecordRefSalesLine: RecordRef;
        i: Integer;
    begin
        RecordRefSalesLine.Open(Database::"Sales Line");
        RecordRefSalesLine.FindFirst();

        Message('RecordRefSalesLine is ' + Format(RecordRefSalesLine.RecordId, 0, 1) + ' Before Pass to function PassRecRefToDoSomething');
        // not passed as var ParameterRecordRefSalesLine
        PassRecRefToDoSomething(RecordRefSalesLine);
        Message('RecordRefSalesLine is ' + Format(RecordRefSalesLine.RecordId, 0, 1) + ' After Pass to function PassRecRefToDoSomething');
        //RecordRefSalesLine is Customer even it is not a var RecordRefSalesLine
        RecordRefSalesLine.Close();

        //How it should be
        i := 1;
        PassVarToDosomething(i);
        Message(Format(i));

        //How it should be
        i := 1;
        PassVarAsVarToDosomething(i);
        Message(Format(i));
    end;

    local procedure PassRecRefToDoSomething(ParameterRecordRefSalesLine: RecordRef)
    var
        CustomerLocal: Record Customer;
        SourceFieldRef: FieldRef;
        SourceRecordRef: RecordRef;
        DataTypeManagement: Codeunit "Data Type Management";
    begin
        Message('RecordRefSalesLine is ' + Format(ParameterRecordRefSalesLine.RecordId, 0, 1) + ' In Function PassRecRefToDoSomething before use DataTypeManagement.GetRecordRefAndFieldRef with ParameterRecordRefSalesLine');
        DataTypeManagement.GetRecordRefAndFieldRef(ParameterRecordRefSalesLine, 2, SourceRecordRef, SourceFieldRef);
        Message('RecordRefSalesLine is ' + Format(ParameterRecordRefSalesLine.RecordId, 0, 1) + ' In Function PassRecRefToDoSomething after use DataTypeManagement.GetRecordRefAndFieldRef with ParameterRecordRefSalesLine');
        //Do some processing with SourceFieldRef.Value
        //and now i want to use the same variable SourceFieldRef to do some other processing for some other record
        //SourceRecordRef.Close(); // comment out to solve the problem
        CustomerLocal.FindFirst();
        DataTypeManagement.GetRecordRefAndFieldRef(CustomerLocal, 2, SourceRecordRef, SourceFieldRef);
        //and the RecRef ParameterRecordRefSalesLine becomes Customer!
        Message('RecordRefSalesLine becomes ' + Format(ParameterRecordRefSalesLine.RecordId, 0, 1) + ' In Function PassRecRefToDoSomething after use DataTypeManagement.GetRecordRefAndFieldRef with Customer');
        //So the SourceRecordRef somehow overwrites ParameterRecordRefSalesLine
    end;

    local procedure PassVarToDosomething(i: Integer)
    var
        j: Integer;
    begin
        j := 5;
        i := j;
    end;

    local procedure PassVarAsVarToDosomething(var i: Integer)
    var
        j: Integer;
    begin
        j := 5;
        i := j;
    end;
}