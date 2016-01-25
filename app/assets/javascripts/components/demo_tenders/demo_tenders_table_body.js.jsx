var DemoTendersTableBody = React.createClass({
  render: function() {
    var rows = [];
    var { tenders, ...other } = this.props;
    for (var i=0; i < tenders.length; i++) {
      var closingDate = strftime.timezone('+0000')('%d %b %Y', new Date(tenders[i].closing_datetime));
      var publishedDate = strftime.timezone('+0000')('%d %b %Y', new Date(tenders[i].published_date));
      var closingTime = strftime.timezone('+0000')('%H:%M %p', new Date(tenders[i].closing_datetime))
      rows.push(<DemoTenderRow key={tenders[i].ref_no} refNo={tenders[i].ref_no} description={tenders[i].description} publishedDate={publishedDate} closingDate={closingDate} closingTime={closingTime} buyerCompanyName={tenders[i].buyer_company_name} index={i} {...other} />);
    }
    return (
      <tbody>
        {rows}
      </tbody>
    );
  }
});