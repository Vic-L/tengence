var PostedTenderRow = React.createClass({
  getTenderPath: function(){
    return "/tenders/" + this.props.refNo + "/edit"
  },
  render: function() {
    return (
      <tr>
        <td>{this.props.description}</td>
        <td>{this.props.publishedDate}</td>
        <td>{this.props.closingDate}</td>
        <td>{this.props.closingTime}</td>
        <td><a className="button edit-button" target="_blank" data-method="get" href={this.getTenderPath()}>Edit</a></td>
        <td><MoreButton refNo={this.props.refNo}/></td>
      </tr>
    );
  }
});
