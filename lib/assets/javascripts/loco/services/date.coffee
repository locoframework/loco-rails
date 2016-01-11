class App.Services.Date
  constructor: (date) -> @date = date

  toString: (format = 'default') ->
    skope = App.I18n[App.Env.loco.getLocale()].date.formats
    switch format
      when 'default' then this.strftime skope.default
      when 'short' then this.strftime skope.short
      when 'long' then this.strftime skope.long
      else
        console.log 'App.Services.Date#toString: unknown format.'

  strftime: (str) ->
    skope = App.I18n[App.Env.loco.getLocale()]
    str = str.replace '%Y', (x) => @date.getFullYear()
    str = str.replace '%y', (x) => @date.getFullYear().toString()[-2..-1]
    str = str.replace '%m', (x) =>
      month = @date.getMonth() + 1
      if month >= 10 then month else "0#{month}"
    str = str.replace '%b', (x) => skope.date.abbr_month_names[@date.getMonth()]
    str = str.replace '%B', (x) => skope.date.month_names[@date.getMonth()]
    str = str.replace '%d', (x) => if @date.getDate() >= 10 then @date.getDate() else "0#{@date.getDate()}"
    str = str.replace '%H', (x) => if @date.getHours() >= 10 then @date.getHours() else "0#{@date.getHours()}"
    str = str.replace '%M', (x) => if @date.getMinutes() >= 10 then @date.getMinutes() else "0#{@date.getMinutes()}"