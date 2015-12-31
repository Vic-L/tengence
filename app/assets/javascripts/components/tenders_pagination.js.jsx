var TendersPagination = React.createClass({
  setPagesRange: function(current_page, total_pages) {
    var range = [], startPage, endPage;
    if ((current_page - 4) < 0) {
      startPage = 1;
    } else {
      startPage = current_page - 4;
    }
    if ((current_page + 4) > total_pages) {
      endPage = total_pages;
    } else {
      endPage = current_page + 4;
    }
    for (var i = startPage; i < endPage; i++) {
      range.push(i);
    }
    return range;
  },
  render: function() {
    if (Object.keys(this.props.pagination).length === 0) return (<div></div>);
    var range = this.setPagesRange(this.props.pagination.current_page, this.props.pagination.total_pages);
    var links = [];
    if (this.props.pagination.current_page !== 1) {
      links.push(<PaginationLink path={this.props.pagination.path} page='1'>« First</PaginationLink>);
      links.push(<PaginationLink path={this.props.pagination.path} page={(this.props.pagination.current_page - 1).toString()}>‹ Prev</PaginationLink>);
    }
    if (range[0] !== 1) {
      links.push(<PaginationLink >…</PaginationLink>); 
    }
    for (var i=0;i<range.length;i++) {
      links.push(<PaginationLink path={this.props.pagination.path} page={range[i].toString()}>{range[i]}</PaginationLink>);
    }
    if (range[range.length - 1] !== this.props.pagination.total_pages) {
      links.push(<PaginationLink >…</PaginationLink>);
    }
    if (!this.props.pagination.last_page) {
      links.push(<PaginationLink path={this.props.pagination.path} page={(this.props.pagination.current_page + 1).toString()}>Next ›</PaginationLink>);
      links.push(<PaginationLink path={this.props.pagination.path} page={(this.props.pagination.total_pages).toString()}>Last »</PaginationLink>);
    }
    return (
      <div className='row'>
        <div className='small-12 column text-right'>
          <nav className="pagination">
            {links}
          </nav> | Total Tenders: 
          <span className="total-count"> {this.props.results_count}</span>
        </div>
      </div>
    );
  }
});