# Pass by Value - RecordRef bug
 The difference between pass-by-reference and pass-by-value is that modifications made to arguments passed in by reference in the called function have effect in the calling function, whereas modifications made to arguments passed in by value in the called function cannot affect the calling function.


Businesses Central AL, using a Variant Data Type and Record Ref’s have a little bug.

Let’s define a RecRef and assign it to a Sales Line table for example and create a function that accepts input parameter Passed by value of type Variant, you can also try with RecordRef.

https://github.com/microsoft/AL/issues/7312
