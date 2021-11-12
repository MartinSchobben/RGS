# Loading the respective dataset and alter ui based on availability

    Code
      data_ui("x")
    Output
      <div class="form-group shiny-input-container">
        <label class="control-label" id="x-dataset-label" for="x-dataset">
          <h5>Selecteer schema</h5>
        </label>
        <div>
          <select id="x-dataset"><option value="Nederland" selected>Nederland</option></select>
          <script type="application/json" data-for="x-dataset" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
        </div>
      </div>

