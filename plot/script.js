let csvData = [];

d3.csv("premier.csv").then(function(data) {
    csvData = data;
    var companies = [...new Set(data.map(row => row['company']))].sort();
    var companySelect = document.getElementById("companySelect");
    companies.forEach(function(company) {
        var option = document.createElement("option");
        option.text = company;
        if (company === 'Thoughtworks') {
            option.selected = true;
        }
        companySelect.add(option);
    });
    companySelect.onchange = function() {
        updatePlot();
    };
    document.getElementById("metricSelect").onchange = function() {
        updatePlot();
    };
    updatePlot();
});

function updatePlot() {
    var company = document.getElementById("companySelect").value;
    var metric = document.getElementById("metricSelect").value;

    var filteredData = csvData.filter(row => row['company'] === company);

    var traces = [];
    var layout = {
        xaxis: {
            title: 'Date',
            showgrid: true,
            gridcolor: '#e0e0e0'
        },
        margin: {
            l: 60,
            r: 60,
            t: 80,
            b: 60
        },
        hovermode: 'x unified',
        showlegend: metric === 'both'
    };

    if (metric === 'certifications' || metric === 'both') {
        traces.push({
            x: filteredData.map(row => row['date']),
            y: filteredData.map(row => parseInt(row['certifications']) || 0),
            name: 'AWS Certifications',
            mode: 'lines+markers',
            type: 'scatter',
            line: { color: '#FF9900', width: 2 },
            marker: { size: 6 }
        });
    }

    if (metric === 'launches' || metric === 'both') {
        traces.push({
            x: filteredData.map(row => row['date']),
            y: filteredData.map(row => parseInt(row['launches']) || 0),
            name: 'Customer Launches',
            mode: 'lines+markers',
            type: 'scatter',
            line: { color: '#232F3E', width: 2 },
            marker: { size: 6 },
            yaxis: metric === 'both' ? 'y2' : 'y'
        });
    }

    if (metric === 'both') {
        layout.title = company + ' - AWS Certifications & Customer Launches';
        layout.yaxis = {
            title: 'AWS Certifications',
            titlefont: { color: '#FF9900' },
            tickfont: { color: '#FF9900' }
        };
        layout.yaxis2 = {
            title: 'Customer Launches',
            titlefont: { color: '#232F3E' },
            tickfont: { color: '#232F3E' },
            overlaying: 'y',
            side: 'right'
        };
    } else if (metric === 'certifications') {
        layout.title = company + ' - AWS Certifications Over Time';
        layout.yaxis = {
            title: 'AWS Certifications',
            showline: false
        };
    } else {
        layout.title = company + ' - Customer Launches Over Time';
        layout.yaxis = {
            title: 'Customer Launches',
            showline: false
        };
    }

    var config = {
        responsive: true,
        displayModeBar: true,
        displaylogo: false,
        modeBarButtonsToRemove: ['lasso2d', 'select2d']
    };

    Plotly.newPlot('myDiv', traces, layout, config);
}