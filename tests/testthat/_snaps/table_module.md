# drill down nesting

    Code
      nested
    Output
      # A tibble: 4,571 x 10
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
      # ... with 4,561 more rows, and 4 more variables: omschrijving <chr>,
      #   referentienummer <chr>, nivo <dbl>, terminal <lgl>

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
      # A tibble: 2,891 x 6
         `Niveau 5`    referentiecode omschrijving     referentienummer  nivo terminal
         <chr>         <chr>          <chr>            <chr>            <dbl> <lgl>   
       1 BIvaKouVvpBeg BIvaKouVvpBeg  Beginbalans (ov~ 0101010.01           5 TRUE    
       2 BIvaKouVvpInv BIvaKouVvpInv  Investeringen k~ 0101010.02           5 TRUE    
       3 BIvaKouVvpAdo BIvaKouVvpAdo  Bij overname ve~ 0101010.03           5 TRUE    
       4 BIvaKouVvpDes BIvaKouVvpDes  Desinvesteringe~ 0101010.04           5 TRUE    
       5 BIvaKouVvpDda BIvaKouVvpDda  Afstotingen kos~ 0101010.05           5 TRUE    
       6 BIvaKouVvpOmv BIvaKouVvpOmv  Omrekeningsvers~ 0101010.06           5 TRUE    
       7 BIvaKouVvpOvm BIvaKouVvpOvm  Overige mutatie~ 0101010.07           5 TRUE    
       8 BIvaKouAkpBeg BIvaKouAkpBeg  Beginbalans (ov~ 0101015.01           5 TRUE    
       9 BIvaKouAkpInv BIvaKouAkpInv  Investeringen k~ 0101015.02           5 TRUE    
      10 BIvaKouAkpAdo BIvaKouAkpAdo  Bij overname ve~ 0101015.03           5 TRUE    
      # ... with 2,881 more rows

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

# Another filtering operation simulating clicking on the sunburst graphic

    Code
      display_data(nestedRGS, labels)
    Output
      # A tibble: 3 x 3
        `Niveau 4` omschrijving                                       referentienummer
        <chr>      <chr>                                              <chr>           
      1 BFvaOveWaa Verkrijgingsprijs overige effecten (langlopend)    0304010         
      2 BFvaOveCuw Cumulatieve afschrijvingen en waardeverminderinge~ 0304020         
      3 BFvaOveCuh Cumulatieve herwaarderingen overige effecten (lan~ 0304030         

# Test that columns of children of levels that don't exist do not appear

    Code
      reformat_data(RGS_xc)
    Output
      # A tibble: 4,569 x 9
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
      # ... with 4,559 more rows, and 3 more variables: referentienummer <chr>,
      #   nivo <dbl>, terminal <lgl>

# Drilldown

    Code
      drill_down(nested[, -c(1:3)], display_data(nested[, -c(1:3)], labels), labels,
      test_modus = TRUE)(1)
    Output
      # A tibble: 7 x 3
        `Niveau 5`    omschrijving                                    referentienummer
        <chr>         <chr>                                           <chr>           
      1 BIvaKouVvpBeg Beginbalans (overname eindsaldo vorig jaar) ko~ 0101010.01      
      2 BIvaKouVvpInv Investeringen kosten van oprichting en van uit~ 0101010.02      
      3 BIvaKouVvpAdo Bij overname verkregen activa kosten van opric~ 0101010.03      
      4 BIvaKouVvpDes Desinvesteringen kosten van oprichting en van ~ 0101010.04      
      5 BIvaKouVvpDda Afstotingen kosten van oprichting en van uitgi~ 0101010.05      
      6 BIvaKouVvpOmv Omrekeningsverschillen kosten van oprichting e~ 0101010.06      
      7 BIvaKouVvpOvm Overige mutaties kosten van oprichting en van ~ 0101010.07      

