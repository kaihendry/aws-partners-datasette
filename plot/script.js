d3.csv("premier.csv").then(function(data) {
    var companies = [...new Set(data.map(row => row['company']))];
    var select = document.getElementById("companySelect");
    companies.forEach(function(company) {
        var option = document.createElement("option");
        option.text = company;
        if (company === 'Thoughtworks') {
            option.selected = true;
        }
        select.add(option);
    });
    select.onchange = function() {
        updatePlot(this.value);
    };
    updatePlot('Thoughtworks');
});

function updatePlot(company) {
    d3.csv("premier.csv").then(function(data) {
        data = data.filter(row => row['company'] === company);
    var trace1 = {
        x: data.map(row => row['date']),
        y: data.map(row => row['certifications']),
        text: data.map(row => row['company']),
        mode: 'lines+markers',
        type: 'scatter'
    };
    var layout = {
        title: 'Company Certifications Over Time',
        xaxis: {
            title: 'Date',
            showgrid: false,
            zeroline: false
        },
        yaxis: {
            title: 'Certifications',
            showline: false
        }
    };
    var data = [trace1];
    Plotly.newPlot('myDiv', data, layout);
    });
}