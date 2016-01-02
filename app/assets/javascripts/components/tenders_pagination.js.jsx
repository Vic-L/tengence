var TendersPagination = React.createClass({
  setPagesRange: function(current_page, total_pages) {
    var range = [], startPage, endPage;
    if ((current_page - 4) <= 0) {
      startPage = 1;
    } else {
      startPage = current_page - 4;
    }
    if ((current_page + 4) > total_pages) {
      endPage = total_pages;
    } else {
      endPage = current_page + 4;
    }
    for (var i = startPage; i <= endPage; i++) {
      range.push(i);
    }
    return range;
  },
  render: function() {
    var {pagination, ...others} = this.props; 
    if (Object.keys(pagination).length === 0) return (<div></div>);
    var range = this.setPagesRange(pagination.current_page, pagination.total_pages);
    var links = [];
    if (pagination.current_page !== 1) {
      links.push(<PaginationLink key='first_page' {...others} path={pagination.path} page='1'>« First</PaginationLink>);
      links.push(<PaginationLink key={'prev_of_' + pagination.current_page} {...others} path={pagination.path} page={(pagination.current_page - 1).toString()}>‹ Prev</PaginationLink>);
    }
    if (range[0] !== 1) {
      links.push(<PaginationLink key='front_ellipsis' showLoading={this.props.showLoading} >…</PaginationLink>); 
    }
    for (var i=0;i<range.length;i++) {
      var current = null;
      if (range[i] === pagination.current_page) current = true;
      links.push(<PaginationLink key={current ? 'current_page_' + range[i] : 'page_' + range[i]} showLoading={this.props.showLoading} currentPage={current} getTenders={this.props.getTenders} path={pagination.path} page={range[i].toString()}>{range[i]}</PaginationLink>);
    }
    if (range[range.length - 1] !== pagination.total_pages) {
      links.push(<PaginationLink key='back_ellipsis' showLoading={this.props.showLoading} >…</PaginationLink>);
    }
    if (!pagination.last_page) {
      links.push(<PaginationLink key={'next_of_' + pagination.current_page} {...others} path={pagination.path} page={(pagination.current_page + 1).toString()}>Next ›</PaginationLink>);
      links.push(<PaginationLink key='last_page' {...others} path={pagination.path} page={(pagination.total_pages).toString()}>Last »</PaginationLink>);
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