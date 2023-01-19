codeunit 50100 "RecRefBug"
{
    trigger OnRun()
    begin
        ProcessRecRef();
    end;

    procedure ProcessRecRef()
    var
        RecordRefSalesLine: RecordRef;
        i: Integer;
    begin
        RecordRefSalesLine.Open(Database::"Sales Line");
        RecordRefSalesLine.FindFirst();

        Message('Pass RecRef To Do Something Use Data Type Management');
        Message('RecordRefSalesLine is ' + Format(RecordRefSalesLine.RecordId, 0, 1) + ' Before Pass to function PassRecRefToDoSomething');
        // not passed as var ParameterRecordRefSalesLine
        PassRecRefToDoSomething(RecordRefSalesLine); //Does not Work
        Message('RecordRefSalesLine is ' + Format(RecordRefSalesLine.RecordId, 0, 1) + ' After Pass to function PassRecRefToDoSomething');
        //RecordRefSalesLine is Customer even it is not a var RecordRefSalesLine
        RecordRefSalesLine.Close();

        Message('Pass RecRef To Do Something Without Data Type Management');
        RecordRefSalesLine.Open(Database::"Sales Line");
        RecordRefSalesLine.FindFirst();
        Message('RecordRefSalesLine is ' + Format(RecordRefSalesLine.RecordId, 0, 1) + ' Before Pass to function PassRecRefToDoSomethingWithoutDataTypeManagement');
        // not passed as var ParameterRecordRefSalesLine
        PassRecRefToDoSomethingWithoutDataTypeManagement(RecordRefSalesLine);
        Message('RecordRefSalesLine is ' + Format(RecordRefSalesLine.RecordId, 0, 1) + ' After Pass to function PassRecRefToDoSomethingWithoutDataTypeManagement');
        //RecordRefSalesLine is Customer even it is not a var RecordRefSalesLine
        RecordRefSalesLine.Close();

        Message('Pass RecRef To Do Something Without Data Type Management RecRef As Variant');
        RecordRefSalesLine.Open(Database::"Sales Line");
        RecordRefSalesLine.FindFirst();
        Message('RecordRefSalesLine is ' + Format(RecordRefSalesLine.RecordId, 0, 1) + ' Before Pass to function PassRecRefToDoSomethingWithoutDataTypeManagementParameterAsVariant');
        // not passed as var ParameterRecordRefSalesLine
        PassRecRefToDoSomethingWithoutDataTypeManagementParameterAsVariant(RecordRefSalesLine);
        Message('RecordRefSalesLine is ' + Format(RecordRefSalesLine.RecordId, 0, 1) + ' After Pass to function PassRecRefToDoSomethingWithoutDataTypeManagementParameterAsVariant');
        //RecordRefSalesLine is Customer even it is not a var RecordRefSalesLine
        RecordRefSalesLine.Close();

        //How it should be
        Message('How it should be i is 1 before function and after since it is not passed as var');
        i := 1;
        PassVarToDosomething(i);
        Message(Format(i));

        //How it should be
        Message('How it should be i is 1 before function and after 5 since it is passed as var');
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

    local procedure PassRecRefToDoSomethingWithoutDataTypeManagement(ParameterRecordRefSalesLine: RecordRef)
    var
        CustomerLocal: Record Customer;
        SourceFieldRef: FieldRef;
        SourceRecordRef: RecordRef;
    begin
        //Message('RecordRefSalesLine is ' + Format(ParameterRecordRefSalesLine.RecordId, 0, 1) + ' In Function PassRecRefToDoSomething before use DataTypeManagement.GetRecordRefAndFieldRef with ParameterRecordRefSalesLine');
        SourceRecordRef := (ParameterRecordRefSalesLine);
        SourceFieldRef := SourceRecordRef.Field(2);
        //Message('RecordRefSalesLine is ' + Format(ParameterRecordRefSalesLine.RecordId, 0, 1) + ' In Function PassRecRefToDoSomething after use DataTypeManagement.GetRecordRefAndFieldRef with ParameterRecordRefSalesLine');
        //Do some processing with SourceFieldRef.Value
        CustomerLocal.FindFirst();
        SourceRecordRef.Get(CustomerLocal.RecordId);
        SourceFieldRef := SourceRecordRef.Field(2);
        //Message('RecordRefSalesLine becomes ' + Format(ParameterRecordRefSalesLine.RecordId, 0, 1) + ' In Function PassRecRefToDoSomething after use DataTypeManagement.GetRecordRefAndFieldRef with Customer');
    end;


    local procedure PassRecRefToDoSomethingWithoutDataTypeManagementParameterAsVariant(ParameterRecordRefSalesLine: Variant)
    var
        CustomerLocal: Record Customer;
        SourceFieldRef: FieldRef;
        SourceRecordRef: RecordRef;
    begin
        Message('RecordRefSalesLine is ' + Format(ParameterRecordRefSalesLine, 0, 1) + ' In Function PassRecRefToDoSomething before use DataTypeManagement.GetRecordRefAndFieldRef with ParameterRecordRefSalesLine');
        SourceRecordRef := ParameterRecordRefSalesLine;
        SourceFieldRef := SourceRecordRef.Field(2);
        Message('RecordRefSalesLine is ' + Format(ParameterRecordRefSalesLine, 0, 1) + ' In Function PassRecRefToDoSomething after use DataTypeManagement.GetRecordRefAndFieldRef with ParameterRecordRefSalesLine');
        //Do some processing with SourceFieldRef.Value
        //and now i want to use the same variable SourceFieldRef to do some other processing for some other record
        CustomerLocal.FindFirst();
        SourceRecordRef.Get(CustomerLocal.RecordId);
        SourceFieldRef := SourceRecordRef.Field(2);
        Message('RecordRefSalesLine becomes ' + Format(ParameterRecordRefSalesLine, 0, 1) + ' In Function PassRecRefToDoSomething after use DataTypeManagement.GetRecordRefAndFieldRef with Customer');
        //Variant ParameterRecordRefSalesLine becomes Customer
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