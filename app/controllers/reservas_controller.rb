class ReservasController < ApplicationController
  # GET /reservas
  # GET /reservas.json
  def index

    if params['fdia'] == nil
      @fdesde = DateTime.now
    else
      @fdesde = DateTime.new(params['fdia'][6..9].to_i,params['fdia'][3..4].to_i,params['fdia'][0..1].to_i,0,0,0)
    end

    @reservas = Array.new
    fiter = DateTime.new(@fdesde.year,@fdesde.month,@fdesde.day,7,0,0)
    fmax =  DateTime.new(@fdesde.year,@fdesde.month,@fdesde.day,21,0,0)

    while fiter < fmax do
      h = Hash.new
      h['hora'] = fiter

      (1..6).each do |c|
        res = Reserva.where('cancha = ? and fdesde >= ? and fdesde < ?', c, fiter, fiter + 15.minutes)
        if res.count > 0 
          h[(c.to_s+'p')] = res[0].players
          h[(c.to_s+'d')] = ((res[0].fhasta - res[0].fdesde)/900).to_i
          h[(c.to_s+'i')] = res[0].id
        end
        res = Reserva.where('cancha = ? and fdesde < ? and fhasta >= ?', c, fiter, fiter + 15.minutes)
        if res.count > 0 
          h[(c.to_s+'p')] = -1
          h[(c.to_s+'d')] = -1
        end

      end




      @reservas << h

      fiter = fiter + 15.minutes
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reservas }
    end
  end

  # GET /reservas/1
  # GET /reservas/1.json
  def show
    @reserva = Reserva.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reserva }
    end
  end

  # GET /reservas/new
  # GET /reservas/new.json
  def new
    @reserva = Reserva.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reserva }
    end
  end

  # GET /reservas/1/edit
  def edit
    @reserva = Reserva.find(params[:id])
  end

  # POST /reservas
  # POST /reservas.json
  def create

    @reserva = Reserva.new()
    @reserva.cancha = params['cancha'].to_i
    @reserva.fdesde = DateTime.new(params['fdesde'][6..9].to_i,params['fdesde'][3..4].to_i,params['fdesde'][0..1].to_i,0,0,0)
    @reserva.fdesde = @reserva.fdesde + params['hdesde'][0..1].to_i.hours + params['hdesde'][3..4].to_i.minutes
    @reserva.fhasta = @reserva.fdesde + params['Duracion'][0..1].to_i.hours + params['Duracion'][3..4].to_i.minutes
    @reserva.players = params['Players']


    respond_to do |format|
      if @reserva.save
        format.html { redirect_to @reserva, notice: 'Reserva was successfully created.' }
        format.json { render json: @reserva, status: :created, location: @reserva }
      else
        format.html { render action: "new" }
        format.json { render json: @reserva.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reservas/1
  # PUT /reservas/1.json
  def update
    @reserva = Reserva.find(params[:id])

    respond_to do |format|
      if @reserva.update_attributes(params[:reserva])
        format.html { redirect_to @reserva, notice: 'Reserva was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reserva.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservas/1
  # DELETE /reservas/1.json
  def destroy
    @reserva = Reserva.find(params[:id])
    @reserva.destroy

    respond_to do |format|
      format.html { redirect_to reservas_url }
      format.json { head :no_content }
    end
  end
end
