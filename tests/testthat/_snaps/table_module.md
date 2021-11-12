# drill down nesting

    Code
      nested
    Output
      # A tibble: 4,571 x 9
         `Niveau 1` `Niveau 2` `Niveau 3` `Niveau 4` `Niveau 5`    referentiecode
         <chr>      <chr>      <chr>      <chr>      <chr>         <chr>         
       1 B          <NA>       <NA>       <NA>       <NA>          B             
       2 B          BIva       <NA>       <NA>       <NA>          BIva          
       3 B          BIva       BIvaKou    <NA>       <NA>          BIvaKou       
       4 B          BIva       BIvaKou    BIvaKouVvp <NA>          BIvaKouVvp    
       5 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpBeg BIvaKouVvpBeg 
       6 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpInv BIvaKouVvpInv 
       7 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpAdo BIvaKouVvpAdo 
       8 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpDes BIvaKouVvpDes 
       9 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpDda BIvaKouVvpDda 
      10 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpOmv BIvaKouVvpOmv 
      # ... with 4,561 more rows, and 3 more variables: omschrijving <chr>,
      #   referentienummer <chr>, nivo <dbl>

---

    Code
      display_data(nested, labels)
    Output
      # A tibble: 2 x 3
        `Niveau 1` omschrijving              referentienummer
        <chr>      <chr>                     <chr>           
      1 B          BALANS                    0               
      2 W          WINST- EN VERLIESREKENING 0               

---

    Code
      reactable::reactable(display_data(nested, labels), details = drill_down(nested,
        display_data(nested, labels), labels))

---

    Code
      reactable::reactable(display_data(nested, labels), details = drill_down(nested,
        display_data(nested, labels), labels), columns = remove_column_names(
        display_data(nested, labels)))

---

    Code
      nested
    Output
      # A tibble: 2,891 x 9
         `Niveau 1` `Niveau 2` `Niveau 3` `Niveau 4` `Niveau 5`    referentiecode
         <chr>      <chr>      <chr>      <chr>      <chr>         <chr>         
       1 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpBeg BIvaKouVvpBeg 
       2 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpInv BIvaKouVvpInv 
       3 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpAdo BIvaKouVvpAdo 
       4 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpDes BIvaKouVvpDes 
       5 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpDda BIvaKouVvpDda 
       6 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpOmv BIvaKouVvpOmv 
       7 B          BIva       BIvaKou    BIvaKouVvp BIvaKouVvpOvm BIvaKouVvpOvm 
       8 B          BIva       BIvaKou    BIvaKouAkp BIvaKouAkpBeg BIvaKouAkpBeg 
       9 B          BIva       BIvaKou    BIvaKouAkp BIvaKouAkpInv BIvaKouAkpInv 
      10 B          BIva       BIvaKou    BIvaKouAkp BIvaKouAkpAdo BIvaKouAkpAdo 
      # ... with 2,881 more rows, and 3 more variables: omschrijving <chr>,
      #   referentienummer <chr>, nivo <dbl>

---

    Code
      display_data(nested, labels)
    Output
      # A tibble: 2,891 x 3
         `Niveau 5`    omschrijving                                   referentienummer
         <chr>         <chr>                                          <chr>           
       1 BIvaKouVvpBeg Beginbalans (overname eindsaldo vorig jaar) k~ 0101010.01      
       2 BIvaKouVvpInv Investeringen kosten van oprichting en van ui~ 0101010.02      
       3 BIvaKouVvpAdo Bij overname verkregen activa kosten van opri~ 0101010.03      
       4 BIvaKouVvpDes Desinvesteringen kosten van oprichting en van~ 0101010.04      
       5 BIvaKouVvpDda Afstotingen kosten van oprichting en van uitg~ 0101010.05      
       6 BIvaKouVvpOmv Omrekeningsverschillen kosten van oprichting ~ 0101010.06      
       7 BIvaKouVvpOvm Overige mutaties kosten van oprichting en van~ 0101010.07      
       8 BIvaKouAkpBeg Beginbalans (overname eindsaldo vorig jaar) k~ 0101015.01      
       9 BIvaKouAkpInv Investeringen kosten van oprichting en van ui~ 0101015.02      
      10 BIvaKouAkpAdo Bij overname verkregen activa kosten van opri~ 0101015.03      
      # ... with 2,881 more rows

