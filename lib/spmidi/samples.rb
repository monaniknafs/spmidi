module SPMidi
  class Samples

    def electric(pitch)
      electric_array = 
        [:elec_triangle,
         :elec_snare,
         :elec_lo_snare,
         :elec_hi_snare,
         :elec_mid_snare,
         :elec_cymbal,
         :elec_soft_kick,
         :elec_filt_snare,
         :elec_fuzz_tom,
         :elec_chime,
         :elec_bong,
         :elec_twang,
         :elec_wood,
         :elec_pop,
         :elec_beep,
         :elec_blip,
         :elec_blip2,
         :elec_ping,
         :elec_bell,
         :elec_flip,
         :elec_tick,
         :elec_hollow_kick,
         :elec_twip,
         :elec_plip,
         :elec_blup]
     return electric_array[pitch - 48]
    end

    def ambi(pitch)
      ambi_array = 
      [:ambi_soft_buzz,
       :ambi_swoosh,
       :ambi_drone,
       :ambi_glass_hum,
       :ambi_glass_rub,
       :ambi_haunted_hum,
       :ambi_piano,
       :ambi_lunar_land,
       :ambi_dark_woosh,
       :ambi_choir]
      return ambi_array[pitch]
    end

    def bass(pitch)
      bass_array =
       [:bass_hit_c,
        :bass_hard_c,
        :bass_thick_c,
        :bass_drop_c,
        :bass_woodsy_c,
        :bass_voxy_c,
        :bass_voxy_hit_c,
        :bass_dnb_f]
      return bass_array[pitch]
    end

    def drum(pitch)
      drum_array = 
        [:drum_heavy_kick,
         :drum_tom_mid_soft,
         :drum_tom_mid_hard,
         :drum_tom_lo_soft,
         :drum_tom_lo_hard,
         :drum_tom_hi_soft,
         :drum_tom_hi_hard,
         :drum_splash_soft,
         :drum_splash_hard,
         :drum_snare_soft,
         :drum_snare_hard,
         :drum_cymbal_soft,
         :drum_cymbal_hard,
         :drum_cymbal_open,
         :drum_cymbal_closed,
         :drum_cymbal_pedal,
         :drum_bass_soft,
         :drum_bass_hard]
      return drum_array[pitch]
    end
  end
end





