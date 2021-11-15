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
      # A tibble: 2,891 x 5
         `Niveau 5`    referentiecode omschrijving              referentienummer  nivo
         <chr>         <chr>          <chr>                     <chr>            <dbl>
       1 BIvaKouVvpBeg BIvaKouVvpBeg  Beginbalans (overname ei~ 0101010.01           5
       2 BIvaKouVvpInv BIvaKouVvpInv  Investeringen kosten van~ 0101010.02           5
       3 BIvaKouVvpAdo BIvaKouVvpAdo  Bij overname verkregen a~ 0101010.03           5
       4 BIvaKouVvpDes BIvaKouVvpDes  Desinvesteringen kosten ~ 0101010.04           5
       5 BIvaKouVvpDda BIvaKouVvpDda  Afstotingen kosten van o~ 0101010.05           5
       6 BIvaKouVvpOmv BIvaKouVvpOmv  Omrekeningsverschillen k~ 0101010.06           5
       7 BIvaKouVvpOvm BIvaKouVvpOvm  Overige mutaties kosten ~ 0101010.07           5
       8 BIvaKouAkpBeg BIvaKouAkpBeg  Beginbalans (overname ei~ 0101015.01           5
       9 BIvaKouAkpInv BIvaKouAkpInv  Investeringen kosten van~ 0101015.02           5
      10 BIvaKouAkpAdo BIvaKouAkpAdo  Bij overname verkregen a~ 0101015.03           5
      # ... with 2,881 more rows

---

    Code
      display_data(nested, labels)
    Output
      # A tibble: 0 x 0

# Test that columns of children of levels that don't exist do not appear

    Code
      reformat_data(RGS_xc)
    Output
      # A tibble: 4,569 x 8
         `Niveau 2` `Niveau 3` `Niveau 4` `Niveau 5`    referentiecode omschrijving   
         <chr>      <chr>      <chr>      <chr>         <chr>          <chr>          
       1 BIva       <NA>       <NA>       <NA>          BIva           Immateriële va~
       2 BIva       BIvaKou    <NA>       <NA>          BIvaKou        Kosten van opr~
       3 BIva       BIvaKou    BIvaKouVvp <NA>          BIvaKouVvp     Verkrijgings- ~
       4 BIva       BIvaKou    BIvaKouVvp BIvaKouVvpBeg BIvaKouVvpBeg  Beginbalans (o~
       5 BIva       BIvaKou    BIvaKouVvp BIvaKouVvpInv BIvaKouVvpInv  Investeringen ~
       6 BIva       BIvaKou    BIvaKouVvp BIvaKouVvpAdo BIvaKouVvpAdo  Bij overname v~
       7 BIva       BIvaKou    BIvaKouVvp BIvaKouVvpDes BIvaKouVvpDes  Desinvestering~
       8 BIva       BIvaKou    BIvaKouVvp BIvaKouVvpDda BIvaKouVvpDda  Afstotingen ko~
       9 BIva       BIvaKou    BIvaKouVvp BIvaKouVvpOmv BIvaKouVvpOmv  Omrekeningsver~
      10 BIva       BIvaKou    BIvaKouVvp BIvaKouVvpOvm BIvaKouVvpOvm  Overige mutati~
      # ... with 4,559 more rows, and 2 more variables: referentienummer <chr>,
      #   nivo <dbl>

