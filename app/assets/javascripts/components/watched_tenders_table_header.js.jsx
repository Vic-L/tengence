var WatchedTendersTableHeader = React.createClass({
  render: function() {
    return (
      <thead>
        <tr>
          <th className="medium-1">
            <input id="select_all" name="select_all" type="checkbox" value="1" />
            <a id="destroy-all-button">
              <i className="fa fa-trash icon"></i>
            </a>
          </th>
          <th className='medium-1'>Status</th>
          <th className='medium-4'>Description</th>
          <th className='medium-1'>Published Date</th>
          <th className='medium-1'>Closing Date</th>
          <th className='medium-1'>Closing Time</th>
          <th className='medium-1'>Buyer Entity</th>
          <th className='medium-1'>Watchlist</th>
          <th className='medium-1'>Details</th>
        </tr>
      </thead>
    );
  }
});