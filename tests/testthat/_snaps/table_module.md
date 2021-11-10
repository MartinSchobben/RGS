# drill down nesting

    Code
      display_data(nested, 2)
    Output
      # A tibble: 42 x 6
         `1`   `2`   `3`   `4`   `5`   omschrijving                              
         <chr> <chr> <chr> <chr> <chr> <chr>                                     
       1 B     BIva  <NA>  <NA>  <NA>  Immateriële vaste activa                  
       2 B     BMva  <NA>  <NA>  <NA>  Materiële vaste activa                    
       3 B     BVas  <NA>  <NA>  <NA>  Vastgoedbeleggingen                       
       4 B     BFva  <NA>  <NA>  <NA>  Financiële vaste activa                   
       5 B     BVrd  <NA>  <NA>  <NA>  Voorraden                                 
       6 B     BPro  <NA>  <NA>  <NA>  Onderhanden projecten (activa)            
       7 B     BVor  <NA>  <NA>  <NA>  Vorderingen                               
       8 B     BEff  <NA>  <NA>  <NA>  Effecten (kortlopend)                     
       9 B     BLim  <NA>  <NA>  <NA>  Liquide middelen                          
      10 B     BEiv  <NA>  <NA>  <NA>  Groepsvermogen - Eigen vermogen - Kapitaal
      # ... with 32 more rows

---

    Code
      reactable::reactable(display_data(nested), details = drill_down(nested))

