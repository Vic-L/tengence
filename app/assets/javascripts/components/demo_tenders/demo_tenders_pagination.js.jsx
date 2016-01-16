var DemoTendersPagination = React.createClass({
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
  handleClick: function(e){
    e.preventDefault();
    Tengence.HomePage.promptRegistration();
  },
  render: function() {
    var {pagination, ...others} = this.props; 
    if (Object.keys(pagination).length === 0) return (<div></div>);
    var range = this.setPagesRange(pagination.current_page, pagination.total_pages);
    var links = [];
    if (pagination.current_page !== 1) {
      links.push(<a href='' onClick={this.handleClick}>« First</a>);
      links.push(<a href='' onClick={this.handleClick}>‹ Prev</a>);
    }
    if (range.length != 0 && range[0] !== 1) {
      links.push(<span>…</span>); 
    }
    for (var i=0;i<range.length;i++) {
      var current = null;
      if (i === 0) {
        links.push(<span>{range[i]}</span>);
      } else {
        links.push(<a href='' className={current ? 'current_page_' + range[i] : 'page_' + range[i]} onClick={this.handleClick}>{range[i]}</a>);
      }
    }
    if (range.length != 0 && range[range.length - 1] !== pagination.total_pages) {
      links.push(<span>…</span>);
    }
    if (!pagination.last_page) {
      links.push(<a href='' onClick={this.handleClick}>Next ›</a>);
      links.push(<a href='' onClick={this.handleClick}>Last »</a>);
    }
    return (
      <div className='row'>
        <div className='small-12 column text-right tender-pagination'>
          <nav className="pagination">
            {links}
          </nav>| Total Tenders:
          <span className="total-count">{this.props.results_count}</span>
        </div>
      </div>
    );
  }
});