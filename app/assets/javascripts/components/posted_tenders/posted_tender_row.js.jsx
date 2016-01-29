var PostedTenderRow = React.createClass({
  renderEditButton: function(){
    if (window.location.href.indexOf('past') === -1) {
      return (<td><a className="button edit-button" target="_blank" data-method="get" href={this.getTenderPath()}>Edit</a></td>);
    } else {
      return (<td>Expired</td>);
    }
  },
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
        {this.renderEditButton()}
        <td><MoreButton refNo={this.props.refNo}/></td>
      </tr>
    );
  }
});
